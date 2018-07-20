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
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) Group *currentGroup;
@property (strong, nonatomic) ChoreAssignment *assignment;


- (IBAction)onTapEditProfile:(id)sender;


@property (weak, nonatomic) NSMutableArray *upcomingChores;
@property (weak, nonatomic) NSMutableArray *pastChores;
@property (nonatomic, weak) id<profileViewControllerDelegate> delegate;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upcomingTableView.delegate = self;
    self.upcomingTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.profilePicture.file = [PFUser currentUser][@"profilePic"];
    [self.profilePicture loadInBackground];
    [self fetchUpcomingChores];
    [self setName:[PFUser currentUser]];
    UIColor *backgroundColor = [UIColor colorWithRed:0.63 green:0.87 blue:1.00 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    self.upcomingTableView.backgroundColor = backgroundColor;
    self.pastTableView.backgroundColor = backgroundColor;

}

- (void)setName:(PFUser *)user{
    _currentUser = user;
     self.userNameLabel.text = self.currentUser.username;
}


- (void)viewDidAppear:(BOOL)animated {
    
    self.profilePicture.file = [PFUser currentUser][@"profilePic"];
    [self.profilePicture loadInBackground];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  */
 



- (IBAction)onTapEditProfile:(id)sender {
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreCell" forIndexPath:indexPath];
    Chore *myChore = self.upcomingChores[indexPath.row];
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
    choreQuery.limit = 1;
    [choreQuery whereKey:@"objectId" equalTo:myChore.objectId];
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil){
            [choreCell setCell: objects[0]];
        }
    }];
    
    choreCell.delegate = self;
    return choreCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.upcomingChores.count;
}

- (void)seeChore:(ChoreInformationCell *)cell withChore:(Chore *)chore {
    [self performSegueWithIdentifier:@"profileSegue" sender:chore];
    
}


@end
