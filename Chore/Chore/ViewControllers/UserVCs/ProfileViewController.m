//
//  ProfileViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.

#import "ProfileViewController.h"
#import "Parse.h"
#import "ParseUI.h"
#import "ChoreInformationCell.h"
#import "ChoreAssignment.h"
#import "GroupCell.h"
#import "HomeViewController.h"
#import "ChoreDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "EmptyCell.h"

@protocol profileViewControllerDelegate;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoreInformationCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *upcomingTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *trophyButton;
@property (weak, nonatomic) IBOutlet UIButton *badgesLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) NSMutableArray<Chore *> *upcomingChores;
@property (strong, nonatomic) NSMutableArray<Chore *> *pastChores;
@property (nonatomic) int numPoints;
@property (nonatomic, weak) id<profileViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *choreControl;
@property (strong, nonatomic) NSMutableDictionary *weeklyChores;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray<Chore *> *overDue;
@property (strong, nonatomic) NSMutableArray<Chore *> *thisWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *nextWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *future;
@property (strong, nonatomic) NSMutableArray *pastTitle;
@property (strong, nonatomic) NSString *weekString;
@property (strong, nonatomic) NSString *futureString;
@property (strong, nonatomic) NSString *overdueString;
@property (strong, nonatomic) NSString *pastString;

@property (nonatomic) BOOL empty;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upcomingTableView.delegate = self;
    self.upcomingTableView.dataSource = self;
    if(self.selectedUser == nil) {
        self.selectedUser = [PFUser currentUser];
    }
    [self setLayout];
    [self refresh];
    self.overdueString = @"Overdue";
    self.weekString = @"This Week";
    self.futureString = @"Future";
    self.pastString = @"Completed";
    self.sectionTitles = [NSMutableArray new];
    [self.sectionTitles insertObject:self.overdueString atIndex:0];
    [self.sectionTitles insertObject:self.weekString atIndex:1];
    [self.sectionTitles insertObject:self.futureString atIndex:2];
    [self.sectionTitles insertObject:self.pastString atIndex:3];

}

- (void)orderChores {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"deadline"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSMutableArray<Chore *> *sortedEventArray = [NSMutableArray arrayWithArray:[self.upcomingChores
                                                                                sortedArrayUsingDescriptors:sortDescriptors]];
    self.upcomingChores = sortedEventArray;
}



- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}
- (void) countForSections{
    self.overDue = [NSMutableArray array];
    self.thisWeek = [NSMutableArray array];
    self.future = [NSMutableArray array];
    NSDate *today = [NSDate date];
    
    for (Chore *currentChore in self.upcomingChores){
        if ([self daysBetweenDate:today andDate:currentChore.deadline] < 0){
            [self.overDue addObject:currentChore];
        } else if ([self daysBetweenDate:today andDate:currentChore.deadline] < 7 && [self daysBetweenDate:today andDate:currentChore.deadline] >= 0){
            [self.thisWeek addObject:currentChore];
        } else {
            [self.future addObject:currentChore];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.choreControl.selectedSegmentIndex = 0;
    [self refresh];
    [self orderChores];
}

- (void)setLayout {
    self.upcomingTableView.rowHeight = UITableViewAutomaticDimension;
    self.upcomingTableView.tableFooterView = [UIView new];
    //self.upcomingTableView.layer.cornerRadius = 10;
    self.upcomingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = self.backgroundColor;
    self.pointsLabel.textColor = darkGreenColor;
    self.badgesLabel.tintColor = darkGreenColor;
    self.progressLabel.textColor = darkGreenColor;
    self.userNameLabel.text = self.selectedUser.username;
    self.navigationItem.title = self.selectedUser.username;

    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width /2;
    if([self.selectedUser.username isEqualToString:[PFUser currentUser].username]) {
        [self.editButton setValue:@NO forKeyPath:@"hidden"];
        [self.trophyButton setValue:@"NO" forKey:@"hidden"];
        [self.badgesLabel setValue:@"NO" forKey:@"hidden"];
        [self.progressLabel setValue:@"YES" forKey:@"hidden"];
        [self.backButton setValue:@YES forKey:@"hidden"];
    } else {
        [self.editButton setValue:@YES forKeyPath:@"hidden"];
        [self.trophyButton setValue:@"YES" forKey:@"hidden"];
        [self.badgesLabel setValue:@"YES" forKey:@"hidden"];
        [self.progressLabel setValue:@"NO" forKey:@"hidden"];
        self.progressLabel.text = [NSString stringWithFormat:@"%0.f%% done", self.progress*100];
    }
}

- (void)refresh {
    [self fetchChores];
    self.profilePicture.file = self.selectedUser[@"profilePic"];
    [self.profilePicture loadInBackground];
}

- (void)fetchChores{
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 1;
    [query whereKey:@"userName" equalTo:self.selectedUser.username];
    [query includeKey:@"uncompletedChores"];
    [query includeKey:@"completedChores"];
    
    PFObject* list = [query getFirstObject];
    NSMutableArray* uncompletedChores = [list objectForKey:@"uncompletedChores"];
    NSMutableArray* completedChores = [list objectForKey:@"completedChores"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            ChoreAssignment *assignment = posts[0];
            self.numPoints = assignment.points;
            self.upcomingChores = uncompletedChores;
            self.pastChores = completedChores;
            self.pointsLabel.text = [NSString stringWithFormat:@"%d points", self.numPoints];
            [self.upcomingTableView reloadData];
            [self orderChores];
            [self countForSections];
            
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.choreControl.selectedSegmentIndex == 1) {
        return [self.pastChores count];
    } else {
        NSInteger sectionCount;
        if (section == 0){
            if ([self.overDue count] == 0){
                sectionCount = [self.thisWeek count];
            }
            sectionCount = [self.overDue count];
        } else if (section == 1){
            if ([self.overDue count] == 0){
                sectionCount = [self.future count];
            }
            sectionCount = [self.thisWeek count];
        } else {
            if ([self.overDue count] == 0){
                sectionCount = 0;
            }
            sectionCount = [self.future count];
        }
        if(sectionCount == 0) {
            return 1;
        } else {
            return sectionCount;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.sectionTitles objectAtIndex: 0] == self.overDue && [self.overDue count] == 0){
        [self.sectionTitles removeAllObjects];
        [self.sectionTitles insertObject:self.weekString atIndex:0];
        [self.sectionTitles insertObject:self.futureString atIndex:1];
        [self.sectionTitles insertObject:self.pastString atIndex:2];
        [self.sectionTitles insertObject:self.pastString atIndex:3];
        return 2;
    } else if (self.choreControl.selectedSegmentIndex == 1) {
        return  1;
        
    } else {
        [self.sectionTitles removeAllObjects];
        [self.sectionTitles insertObject:self.overdueString atIndex:0];
        [self.sectionTitles insertObject:self.weekString atIndex:1];
        [self.sectionTitles insertObject:self.futureString atIndex:2];
        [self.sectionTitles insertObject:self.pastString atIndex:3];
        return 3;
    }
    
    
    
}

- (CGFloat):(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIColor *color = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    [view setBackgroundColor:color];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setTextColor:[UIColor whiteColor]];
    label.font = [UIFont fontWithName:@"Avenir" size:18];
    NSString *string;
    if(self.choreControl.selectedSegmentIndex == 1){
        string = @"Completed";
    } else {
        string =[self.sectionTitles objectAtIndex:section];
    }
    [label setText:string];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}


- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.choreControl.selectedSegmentIndex == 1) {
        if([self.pastChores count] == 0) {
            EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
            [emptyCell setCell:@"No completed chores"];
            return emptyCell;
        } else {
            ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
            choreCell.delegate = self;
            Chore *myPastChore = self.pastChores[indexPath.row];
            [choreCell setCell:myPastChore withColor:self.backgroundColor];
            choreCell.deadlineLabel.hidden = YES;
            return choreCell;
        }
    } else {
        Chore *myUpcomingChore;
        if(indexPath.section == 0 && [self.overDue count] != 0) {
                ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
                myUpcomingChore = self.upcomingChores[indexPath.row];
                choreCell.delegate = self;
                [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
                choreCell.deadlineLabel.hidden = NO;
                return choreCell;
        
        } else if(indexPath.section == 1) {
            if([self.thisWeek count] == 0) {
                EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
                [emptyCell setCell:@"No chores for this week"];
                return emptyCell;
            } else {
                ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
                unsigned long actualRow = [self.overDue count] + indexPath.row;
                myUpcomingChore = self.upcomingChores[actualRow];
                choreCell.delegate = self;
                [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
                choreCell.deadlineLabel.hidden = NO;
                return choreCell;
            }
        } else if([self.future count] == 0) {
            EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
            [emptyCell setCell:@"No chores for the future"];
            return emptyCell;
        } else {
            ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
            unsigned long actualRow = [self.overDue count] + [self.thisWeek count]+ indexPath.row;
            myUpcomingChore = self.upcomingChores[actualRow];
            choreCell.delegate = self;
            [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
            choreCell.deadlineLabel.hidden = NO;
            return choreCell;
        }
    }
}

- (void)seeChore: (ChoreInformationCell *)cell withChore: (Chore *)chore withName:(NSString *)userName {
    [self performSegueWithIdentifier:@"profileToDetailsSegue" sender:chore];
}

- (IBAction)didTapControl:(id)sender {
    [self.upcomingTableView reloadData];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSettings:(id)sender {
    NSLog(@"Settings Button tapped");
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];

}

- (void)setUserProfileImage {
    self.profilePicture.file = (PFFile *)self.selectedUser[@"profilePic"];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
//    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(1024, 768)];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    self.photo = resizedImage;
//    [self.profilePicture setImage:resizedImage];
//
//    if(self.photo != nil) {
//        NSData *imageData = UIImagePNGRepresentation(self.photo);
//        self.selectedUser[@"profilePic"] = [PFFile fileWithData:imageData];
//        [self.selectedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            if(succeeded) {
//                NSLog(@"Saved edits!");
//            } else {
//                NSLog(@"Error: %@", error);
//            }
//        }];
//    }
//}
//
//- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
//    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
//    resizeImageView.image = image;
//    UIGraphicsBeginImageContext(size);
//    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"broom"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No chores";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:20],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ((self.choreControl.selectedSegmentIndex == 0) ?
                      @"There are no chores to be completed at this time." :
                      @"There are no chores that have been completed at this time.");
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:16],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (IBAction)didTapBadge:(id)sender {
    [self performSegueWithIdentifier:@"badgeSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *controller = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"profileToDetailsSegue"]){
        ChoreDetailsViewController *detailsController = (ChoreDetailsViewController *)controller;
        detailsController.chore = sender;
    }
}

@end
