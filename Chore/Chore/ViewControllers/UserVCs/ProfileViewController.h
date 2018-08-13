//
//  ProfileViewController.h
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import "ParseUI.h"
#import "ChoreInformationCell.h"
#import "ChoreAssignment.h"
#import "GroupCell.h"
#import "HomeViewController.h"
#import "ChoreDetailsViewController.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) PFUser *selectedUser;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSMutableDictionary *weeklyChores;
@property (strong, nonatomic) NSMutableArray<Chore *> *upcomingChores;
@property (strong, nonatomic) NSMutableArray<Chore *> *pastChores;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray<Chore *> *overDue;
@property (strong, nonatomic) NSMutableArray<Chore *> *thisWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *future;
@property (strong, nonatomic) NSMutableArray *pastTitle;
@property (strong, nonatomic) NSString *weekString;
@property (strong, nonatomic) NSString *futureString;
@property (strong, nonatomic) NSString *overdueString;
@property (nonatomic) long actualRow;
@property (nonatomic) BOOL empty;
@property (nonatomic) int numPoints;
@property (nonatomic) float progress;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UITableView *upcomingTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *choreControl;

@end

