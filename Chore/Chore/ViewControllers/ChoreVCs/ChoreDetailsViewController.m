//
//  ChoreDetailsViewController.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ChoreDetailsViewController.h"
#import "ProfileViewController.h"
#import "ChoreInformationViewController.h"


@interface ChoreDetailsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ChoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChoreDetails];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.chorePic.file = [PFUser currentUser][@"chorePicture"];
    [self.chorePic loadInBackground];

}

- (void)viewDidAppear:(BOOL)animated{
    self.chorePic.file = [PFUser currentUser][@"chorePicture"];
    [self.chorePic loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapeDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setChoreDetails {
    self.userNameLabel.text = self.userName;
    self.choreNameLabel.text = self.chore.name;
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@", self.chore.deadline];
    self.pointLabel.text = [NSString stringWithFormat: @"%d", self.chore.points];
    self.informationLabel.text = self.chore.info;
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTapAddPic:(id)sender {
}

@end
