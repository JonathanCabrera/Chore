//
//  ProfileViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

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
@property (weak, nonatomic) NSMutableArray *upcomingChores;
@property (weak, nonatomic) NSMutableArray *pastChores;
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
    self.activityIndicator.hidesWhenStopped = YES;
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.assignment = posts[0];
            self.numPoints = self.assignment.points;
            self.pointsLabel.text = [NSString stringWithFormat:@"%d points", self.numPoints];
            self.upcomingChores = self.assignment.uncompletedChores;
            self.pastChores = self.assignment.completedChores;
            [self.upcomingTableView reloadData];
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
    if(self.choreControl.selectedSegmentIndex == 1) {
        Chore *myPastChore = self.pastChores[indexPath.section];
        PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
        choreQuery.limit = 1;
        [choreQuery whereKey:@"objectId" equalTo:myPastChore.objectId];
        [choreQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects != nil){
                [choreCell setCell:objects[0] withColor:self.backgroundColor];
                choreCell.deadlineLabel.hidden = YES;
            }
        }];
    } else {
        Chore *myChore = self.upcomingChores[indexPath.section];
        PFQuery *choreQuery2 = [PFQuery queryWithClassName:@"Chore"];
        choreQuery2.limit = 1;
        [choreQuery2 whereKey:@"objectId" equalTo:myChore.objectId];
        [choreQuery2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
            if (posts != nil){
                [choreCell setCell:posts[0] withColor:self.backgroundColor];
                choreCell.deadlineLabel.hidden = NO;
            }
        }];
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
    NSString *text = @"No Chores";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ((self.choreControl.selectedSegmentIndex == 0) ?
                      @"There are no chores to be completed at this time." :
                      @"There are no chores that have been completed at this time.");
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
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
