//
//  AddChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddChoreViewController.h"
#import "ChoreAssignment.h"
#import "DefaultChore.h"
#import <STPopup/STPopup.h>
#import "CreateChoreViewController.h"
#import "AssignChoreCell.h"
#import "AssignUserCell.h"
#import "RepeatChoreViewController.h"

@interface AddChoreViewController () <UITableViewDelegate, UITableViewDataSource, AssignUserCellDelegate, AssignChoreCellDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *deadlineButton;
@property (weak, nonatomic) IBOutlet UIButton *customChoreButton;
@property (weak, nonatomic) IBOutlet UITableView *choreMenu;
@property (weak, nonatomic) IBOutlet UITableView *userMenu;
@property (weak, nonatomic) IBOutlet UIButton *selectChoreButton;
@property (weak, nonatomic) IBOutlet UIButton *selectUserButton;
@property (weak, nonatomic) IBOutlet UISearchBar *choreSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allChores;
@property (nonatomic, strong) NSMutableArray *filteredChores;
@property (nonatomic, strong) NSString *userToAssign;
@property (nonatomic, strong) DefaultChore *choreToAssign;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *darkGreenColor;

@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choreMenu.dataSource = self;
    self.choreMenu.delegate = self;
    self.userMenu.dataSource = self;
    self.userMenu.delegate = self;
    [self.choreMenu setHidden:YES];
    [self.userMenu setHidden:YES];
    self.choreMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.choreSearchBar.delegate = self;
    self.currDate = [NSDate date];
    
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenus)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    
    [self setLayout];
    [self fetchData];
}

- (void)setLayout {
    self.backgroundColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.choreMenu.backgroundColor = self.backgroundColor;
    self.choreMenu.layer.borderWidth = 0.8f;
    self.choreMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.choreMenu.layer.cornerRadius = 20;
    self.userMenu.backgroundColor = self.backgroundColor;
    self.userMenu.layer.borderWidth = 0.8f;
    self.userMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.userMenu.layer.cornerRadius = 20;
    self.customChoreButton.layer.borderWidth = 0.8f;
    self.customChoreButton.layer.cornerRadius = 20;
    self.customChoreButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.deadlineButton.layer.borderWidth = 0.8f;
    self.deadlineButton.layer.cornerRadius = 20;
    self.deadlineButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.selectUserButton.layer.borderWidth = 0.8f;
    self.selectUserButton.layer.cornerRadius = 20;
    self.selectUserButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.selectChoreButton.layer.borderWidth = 0.8f;
    self.selectChoreButton.layer.cornerRadius = 20;
    self.selectChoreButton.layer.borderColor = self.darkGreenColor.CGColor;
}

- (void) refreshDeadline{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *formattedDate = [formatter stringFromDate:self.currDate];
    self.deadlineButton.titleLabel.text = [NSString stringWithFormat:@"%@", formattedDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchData {
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"DefaultChore"];
    [choreQuery orderByAscending:@"name"];
    choreQuery.limit = 30;
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allChores = (NSMutableArray *)posts;
            self.filteredChores = self.allChores;
            [self.choreMenu reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    userQuery.limit = 20;
    [userQuery orderByAscending:@"userName"];
    [userQuery whereKey:@"groupName" equalTo:self.currentGroup];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            self.userArray = (NSMutableArray *)objects;
            [self.userMenu reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapSelectChore:(id)sender {
    [self.userMenu setHidden:YES];
    [self.choreMenu setHidden:NO];
}

- (IBAction)didTapSelectUser:(id)sender {
    [self.choreMenu setHidden:YES];
    [self.userMenu setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.choreMenu]) {
        return [self.filteredChores count];
    } else {
        return [self.userArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.choreMenu]) {
        AssignChoreCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"AssignChoreCell" forIndexPath:indexPath];
        [choreCell setCell:self.filteredChores[indexPath.row]];
        choreCell.delegate = self;
        return choreCell;
    } else {
        AssignUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"AssignUserCell" forIndexPath:indexPath];
        [userCell setCell:self.userArray[indexPath.row]];
        userCell.delegate = self;
        return userCell;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", searchText];
        self.filteredChores = (NSMutableArray *) [self.allChores filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredChores = self.allChores;
    }
    [self.choreMenu reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.choreSearchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.choreSearchBar.showsCancelButton = NO;
    self.choreSearchBar.text = @"";
    [self.choreSearchBar resignFirstResponder];
    [self closeMenus];
}

- (void)selectChore:(AssignChoreCell *)choreCell withChore:(DefaultChore *)chore {
    self.choreToAssign = chore;
    self.selectChoreButton.backgroundColor = self.backgroundColor;
    self.selectChoreButton.titleLabel.text = self.choreToAssign.name;
    [self performSelector:@selector(closeMenus) withObject:nil afterDelay:0.2];
}

- (void)selectUser:(AssignUserCell *)userCell withUserName:(NSString *)userName {
    self.userToAssign = userName;
    self.selectUserButton.backgroundColor = self.backgroundColor;
    self.selectUserButton.titleLabel.text = self.userToAssign;
    [self performSelector:@selector(closeMenus) withObject:nil afterDelay:0.2];
}

- (void)closeMenus {
    [self.choreMenu setHidden:YES];
    [self.userMenu setHidden:YES];
}

- (IBAction)didTapRepeat:(id)sender {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"repeatChore" bundle:nil] instantiateViewControllerWithIdentifier:@"RepeatChoreViewController"]];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)]];
    [popupController presentInViewController:self];
}


- (IBAction)didTapCancel:(id)sender {
    [self closeMenus];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAssignment:(id)sender {
    [self closeMenus];
    Chore *newChore = [Chore makeChore:self.choreToAssign.name withDescription:self.choreToAssign.info withPoints:self.choreToAssign.points withDeadline:_currDate withUserName:self.userToAssign withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"created chore");
        } else {
            NSLog(@"error creating chore: %@", error.localizedDescription);
        }
    }];
    
    [ChoreAssignment assignChore:self.userToAssign withChore:newChore withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Assigned chore!");
        } else {
            NSLog(@"Error assigning chore: %@", error.localizedDescription);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapDeadline:(id)sender {
    [self closeMenus];
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.currDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:NO];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableYearSwitch:YES];
    [self.datePicker setDaysInHistorySelection:0];
    [self.datePicker setDaysInFutureSelection:0];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColorSelected:[UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(.5),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.currDate = datePicker.date;
    self.deadlineButton.backgroundColor = self.backgroundColor;
    [self refreshDeadline];
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (IBAction)didTapCustom:(id)sender {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"createChore" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateChoreViewController"]];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)]];
    [popupController presentInViewController:self];
}

- (void)didTapBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
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
