//
//  AddChoreViewController.h
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THDatePickerViewController.h"
#import "ChoreAssignment.h"
#import "DefaultChore.h"
#import <STPopup/STPopup.h>
#import "CreateChoreViewController.h"
#import "AssignChoreCell.h"
#import "AssignUserCell.h"
#import "UIViewController+LCModal.h"
#import "RepeatChoreViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "CreateCustomChoreCell.h"

@interface AddChoreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *deadlineButton;
@property (weak, nonatomic) IBOutlet UITableView *choreMenu;
@property (weak, nonatomic) IBOutlet UITableView *userMenu;
@property (weak, nonatomic) IBOutlet UIButton *selectChoreButton;
@property (weak, nonatomic) IBOutlet UIButton *selectUserButton;
@property (weak, nonatomic) IBOutlet UISearchBar *choreSearchBar;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allChores;
@property (nonatomic, strong) NSMutableArray *filteredChores;
@property (strong, nonatomic) NSString *currentGroup;
@property (nonatomic, strong) NSString *userToAssign;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) DefaultChore *choreToAssign;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *darkGreenColor;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) BOOL doneSaving;
@property (nonatomic) BOOL doneCreating;
@property (nonatomic) BOOL repeating;

@end
