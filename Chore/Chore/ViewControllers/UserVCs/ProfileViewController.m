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
@property (weak, nonatomic) IBOutlet UIButton *trophyButton;
@property (weak, nonatomic) IBOutlet UIButton *badgesLabel;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) NSMutableArray<Chore *> *upcomingChores;
@property (strong, nonatomic) NSMutableArray<Chore *> *pastChores;
@property (nonatomic) int numPoints;
@property (nonatomic, weak) id<profileViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *choreControl;

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
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    self.choreControl.selectedSegmentIndex = 0;
    [self refresh];
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
    self.badgesLabel.tintColor = darkGreenColor;
    self.userNameLabel.text = self.selectedUser.username;
    self.navigationItem.title = self.selectedUser.username;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width /2;
    if([self.selectedUser.username isEqualToString:[PFUser currentUser].username]) {
        [self.editButton setValue:@NO forKeyPath:@"hidden"];
        [self.trophyButton setValue:@"NO" forKey:@"hidden"];
        [self.backButton setValue:@YES forKey:@"hidden"];
    } else {
        [self.editButton setValue:@YES forKeyPath:@"hidden"];
        [self.trophyButton setValue:@"YES" forKey:@"hidden"];
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
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (void)orderChores {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"deadline"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSMutableArray<Chore *> *sortedPastChores = [NSMutableArray arrayWithArray:[self.pastChores
                                                                                sortedArrayUsingDescriptors:sortDescriptors]];
    NSMutableArray<Chore *> *sortedUpcomingChores = [NSMutableArray arrayWithArray:[self.upcomingChores
                                                                                sortedArrayUsingDescriptors:sortDescriptors]];
    self.pastChores = sortedPastChores;
    self.upcomingChores = sortedUpcomingChores;
}

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
    if(self.choreControl.selectedSegmentIndex == 1) {
        Chore *myPastChore = self.pastChores[indexPath.section];
        [choreCell setCell:myPastChore withColor:self.backgroundColor];
    } else {
        Chore *myUpcomingChore = self.upcomingChores[indexPath.section];
        [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
    }
    choreCell.delegate = self;
    return choreCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.choreControl.selectedSegmentIndex == 1) {
        return [self.pastChores count];
    } else {
        return [self.upcomingChores count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
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
