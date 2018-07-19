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

@protocol profileViewControllerDelegate;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *upcomingTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)onTapEditProfile:(id)sender;


@property (weak, nonatomic) NSArray *upcomingChores;
//
@property (nonatomic, weak) id<profileViewControllerDelegate> delegate;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.profilePicture.file = [PFUser currentUser][@"profilePic"];
    [self.profilePicture loadInBackground];

}


- (void)viewDidAppear:(BOOL)animated {
    
    self.profilePicture.file = [PFUser currentUser][@"profilePic"];
    NSLog(@"check");
    [self.profilePicture loadInBackground];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)onTapEditProfile:(id)sender {
}
@end
