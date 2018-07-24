//
//  GroupOptionsViewController.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "GroupOptionsViewController.h"
#import "Group.h"
#import "GroupInfoViewController.h"
#import "ChoreInformationViewController.h"

@interface GroupOptionsViewController ()
@property (weak, nonatomic) IBOutlet UIView *seeGroupView;
@property (weak, nonatomic) IBOutlet UIView *seeChoresView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *choreLabel;


@end

@implementation GroupOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    UIColor *lightGreenColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    
    self.view.backgroundColor = backgroundColor;
    self.groupNameLabel.textColor = darkGreenColor;
    self.groupLabel.textColor = lightGreenColor;
    self.choreLabel.textColor = lightGreenColor;
    self.seeGroupView.layer.cornerRadius = 40;
    self.seeGroupView.clipsToBounds = true;
    self.seeGroupView.backgroundColor = darkGreenColor;
    self.seeChoresView.layer.cornerRadius = 40;
    self.seeChoresView.clipsToBounds = true;
    self.seeChoresView.backgroundColor = darkGreenColor;
    
    //fetch the user's group
    NSString *usersGroup = [PFUser currentUser][@"groupName"];
    if(usersGroup != nil) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        query.limit = 1;
        [query whereKey:@"name" equalTo:usersGroup];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts != nil) {
                self.currentGroup = posts[0];
                self.groupNameLabel.text = self.currentGroup.name;
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
        NSLog(@"user has no group");
    }
     
    UITapGestureRecognizer *seeGroupRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSeeGroup)];
    [self.seeGroupView addGestureRecognizer:seeGroupRecognizer];
    
    UITapGestureRecognizer *seeChoresRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSeeChores)];
    [self.seeChoresView addGestureRecognizer:seeChoresRecognizer];
     
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapSeeGroup {
    [self performSegueWithIdentifier:@"groupInfoSegue" sender:self.currentGroup];
}

- (void)didTapSeeChores {
    [self performSegueWithIdentifier:@"choreInfoSegue" sender:self.currentGroup];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"groupInfoSegue"]) {
        
        GroupInfoViewController *groupInfoController = (GroupInfoViewController *)nextController;
        groupInfoController.currentGroup = self.currentGroup;
        
    } else if([segue.identifier isEqualToString:@"choreInfoSegue"]) {
        
        ChoreInformationViewController *choreInfoController = (ChoreInformationViewController *)nextController;
        choreInfoController.currentGroup = self.currentGroup;
        
    }
    
}


@end
