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

@protocol profileViewControllerDelegate;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoreInformationCellDelegate>
@property (strong, nonatomic) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *upcomingTableView;
@property (weak, nonatomic) IBOutlet UITableView *pastTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) Group *currentGroup;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) ChoreAssignment *pastAssignment;


@property (weak, nonatomic) NSMutableArray *upcomingChores;
@property (weak, nonatomic) NSMutableArray *pastChores;
@property (nonatomic, weak) id<profileViewControllerDelegate> delegate;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upcomingTableView.delegate = self;
    self.upcomingTableView.dataSource = self;
    self.pastTableView.delegate = self;
    self.pastTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.profilePicture.file = [PFUser currentUser][@"profilePic"];
    [self.profilePicture loadInBackground];
    [self fetchUpcomingChores];
    [self fetchPastChores];
    [self setName:[PFUser currentUser]];
    UIColor *backgroundColor = [UIColor colorWithRed:0.63 green:0.87 blue:1.00 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    self.upcomingTableView.backgroundColor = backgroundColor;
    self.pastTableView.backgroundColor = backgroundColor;
}

- (void)setName:(PFUser *)user{
    self.selectedUser = user;
     self.userNameLabel.text = self.currentUser.username;
}

- (void)fetchUpcomingChores{
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 1;
    [query whereKey:@"userName" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.assignment = posts[0];
            self.upcomingChores = self.assignment.uncompletedChores;
            [self.upcomingTableView reloadData];
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (void) fetchPastChores{
    PFQuery *pastQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    pastQuery.limit = 1;
    [pastQuery whereKey:@"userName" equalTo:[PFUser currentUser].username];
    [pastQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil){
            self.pastAssignment = posts[0];
            self.pastChores = self.pastAssignment.uncompletedChores;
            [self.pastTableView reloadData];
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([tableView isEqual:self.upcomingTableView]){
        ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
        Chore *myChore = self.upcomingChores[indexPath.row];
        
        PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
        choreQuery.limit = 1;
        [choreQuery whereKey:@"objectId" equalTo:myChore.objectId];
        [choreQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects != nil){
                [choreCell setCell:objects[0] withName:@"UpcomingCell"];
            }
        }];
        choreCell.delegate = self;
        return choreCell;
    } else {
            ChoreInformationCell *pastChoreCell = [tableView dequeueReusableCellWithIdentifier:@"PastChoreCell" forIndexPath:indexPath];
            Chore *myPastChore = self.pastChores[indexPath.row];
            
            PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
            choreQuery.limit = 1;
            [choreQuery whereKey:@"objectId" equalTo:myPastChore.objectId];
            [choreQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (objects != nil){
                    [pastChoreCell setCell:objects[0] withName:@"PastCell"];
                }
            }];
            pastChoreCell.delegate = self;
            return pastChoreCell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.upcomingChores.count;
}

- (void)seeChore:(ChoreInformationCell *)cell withChore:(Chore *)chore {
    [self performSegueWithIdentifier:@"profileSegue" sender:chore];
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
                [self dismissViewControllerAnimated:YES completion:nil];
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

/*
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 */

@end
