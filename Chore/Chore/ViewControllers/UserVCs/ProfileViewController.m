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

@protocol profileViewControllerDelegate;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoreInformationCellDelegate,  DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *upcomingTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
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
@property (strong, nonatomic) NSMutableArray<Chore *> *thisWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *nextWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *future;
@property (strong, nonatomic) NSMutableArray *pastTitle;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upcomingTableView.delegate = self;
    self.upcomingTableView.dataSource = self;
    self.upcomingTableView.emptyDataSetSource = self;
    self.upcomingTableView.emptyDataSetDelegate = self;
    
    if(self.selectedUser == nil) {
        self.selectedUser = [PFUser currentUser];
    }
    [self setLayout];
    self.activityIndicator.hidesWhenStopped = YES;
    [self refresh];
    NSString *first = @"This Week";
    NSString *second = @"Next Week";
    NSString *third = @"Future";
    NSString *past = @"Completed";
    self.sectionTitles = [NSMutableArray new];
    [self.sectionTitles insertObject:first atIndex:0];
    [self.sectionTitles insertObject:second atIndex:1];
    [self.sectionTitles insertObject:third atIndex:2];
    [self.sectionTitles insertObject:past atIndex:3];
    [self setSectionTitles:self.sectionTitles];

    
  
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

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
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
    
    self.thisWeek = [NSMutableArray array];
    self.nextWeek = [NSMutableArray array];
    self.future = [NSMutableArray array];
    NSDate *today = [NSDate date];
    
    for (Chore *currentChore in self.upcomingChores){
        
        if ([self daysBetweenDate:today andDate:currentChore.deadline] > 7 && [self daysBetweenDate:today andDate:currentChore.deadline] < 14){
            [self.nextWeek addObject:currentChore];
        } else if ([self daysBetweenDate:today andDate:currentChore.deadline] < 7){
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
    self.upcomingTableView.layer.cornerRadius = 10;
    self.upcomingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = self.backgroundColor;
    self.pointsLabel.textColor = darkGreenColor;
    self.userNameLabel.text = self.selectedUser.username;
    self.navigationItem.title = self.selectedUser.username;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width /2;
    if([self.selectedUser.username isEqualToString:[PFUser currentUser].username]) {
        [self.editButton setValue:@NO forKeyPath:@"hidden"];
        [self.backButton setValue:@YES forKey:@"hidden"];
    } else {
        [self.editButton setValue:@YES forKeyPath:@"hidden"];
    }
}

- (void)refresh {
    [self.activityIndicator startAnimating];
    [self fetchChores];
    self.profilePicture.file = self.selectedUser[@"profilePic"];
    [self.profilePicture loadInBackground];
    [self.activityIndicator stopAnimating];
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
            sectionCount = [self.thisWeek count];
            
        } else if (section == 1){
            sectionCount = [self.nextWeek count];
        } else {
            sectionCount = [self.future count];
        }
        
        return sectionCount;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.choreControl.selectedSegmentIndex == 1) {
        return 1;
    } else {
    return 3;
    }
}



- (CGFloat):(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string;
    if(self.choreControl.selectedSegmentIndex == 1){
        string = [self.sectionTitles objectAtIndex:3];
    } else {
        string =[self.sectionTitles objectAtIndex:section];
    }
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}


- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
    if(self.choreControl.selectedSegmentIndex == 1) {
        Chore *myPastChore = self.pastChores[indexPath.row];
        [choreCell setCell:myPastChore withColor:self.backgroundColor];
        choreCell.deadlineLabel.hidden = YES;
    } else {
        Chore *myUpcomingChore;
        if(indexPath.section == 0) {
            myUpcomingChore = self.upcomingChores[indexPath.row];
        } else if(indexPath.section == 1) {
            unsigned long actualRow = [self.thisWeek count] + indexPath.row;
            myUpcomingChore = self.upcomingChores[actualRow];
        } else {
            unsigned long actualRow = [self.thisWeek count] + [self.nextWeek count] + indexPath.row;
            myUpcomingChore = self.upcomingChores[actualRow];
        }

        [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
        choreCell.deadlineLabel.hidden = NO;
       
    }
    choreCell.delegate = self;
    return choreCell;
    

}

- (void)seeChore: (ChoreInformationCell *)cell withChore: (Chore *)chore withName:(NSString *)userName {
    [self performSegueWithIdentifier:@"profileToDetailsSegue" sender:chore];
}

- (IBAction)didTapControl:(id)sender {
    [self.activityIndicator startAnimating];
    [self.upcomingTableView reloadData];
    [self.activityIndicator stopAnimating];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapEdit:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    UIAlertController *pictureViewController = [UIAlertController alertControllerWithTitle:@"Change profile picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [pictureViewController addAction:cameraAction];
    [pictureViewController addAction:galleryAction];
    [pictureViewController addAction:cancelAction];
    [self presentViewController:pictureViewController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(1024, 768)];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photo = resizedImage;
    [self.profilePicture setImage:resizedImage];
    
    if(self.photo != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.photo);
        self.selectedUser[@"profilePic"] = [PFFile fileWithData:imageData];
        [self.selectedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                NSLog(@"Saved edits!");
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

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
