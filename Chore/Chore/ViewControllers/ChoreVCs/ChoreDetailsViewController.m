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

@interface ChoreDetailsViewController ()

@end

@implementation ChoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setupafter loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapeDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setChoreDetails {
    
    self.choreNameLabel.text = self.chore.name;
    self.userNameLabel.text = self.chore.user.username;
    self.deadlineLabel.text = self.chore.deadline;
    self.pointLabel.text = [NSString stringWithFormat: @"%d", self.chore.points];
    self.informationLabel.text = self.chore.info;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
