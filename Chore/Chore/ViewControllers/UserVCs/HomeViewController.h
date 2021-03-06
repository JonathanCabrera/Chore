//
//  HomeViewController.h
//  Chore
//
//  Created by Katie Kwan on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse.h"
#import "ParseUI.h"
#import "CircleProgressBar.h"
#import "Group.h"
#import "Chore.h"
#import "ChoreAssignment.h"
#import "ProgressCell.h"
#import "ProfileViewController.h"
#import "AddChoreViewController.h"

@interface HomeViewController : UIViewController
@property (strong, nonatomic) NSString *currentGroup;
@property (nonatomic) CGFloat progressBarWidth;
@property (weak, nonatomic) IBOutlet UIView *doneView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) IBOutlet CircleProgressBar *progressBar;
@property (nonatomic) UIColor *progressBarProgressColor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIColor *progressBarTrackColor;
@property (nonatomic) CGFloat startAngle;
@property (strong, nonatomic) NSMutableArray<ChoreAssignment *> *allAssignments;
@property (strong, nonatomic) NSMutableArray<Chore *> *chores;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) NSMutableArray *userNames;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) long currNumberOfChores;
@property (nonatomic) long currCompletedChores;
@property (nonatomic) long memberNumberOfChores;
@property (weak, nonatomic) IBOutlet UIButton *middleChoreButton;
@property (strong, nonatomic) UIColor *bgColor;
@property (nonatomic) long memberCompletedChores;
@property (nonatomic) float increment;
@property (nonatomic) float memberIncrement;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *viewColor;
@property (nonatomic, strong) NSNumber *memberIncrementNSNum;
@property (nonatomic, strong) NSNumber *memberPoint;
@property (nonatomic, strong) NSMutableArray *membersProgress;
@property (nonatomic, strong) NSMutableArray *membersPoints;
@property (nonatomic) float progressToSend;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UILabel *myPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *myUsernameLabel;

- (IBAction)onTapProgressButton:(id)sender;
@end
