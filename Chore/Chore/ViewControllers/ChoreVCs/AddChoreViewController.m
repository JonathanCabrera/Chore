//
//  AddChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddChoreViewController.h"
#import "AddChoreCell.h"
#import "AssignUserCell.h"
#import "ChoreAssignment.h"

@interface AddChoreViewController () <UITableViewDelegate, UITableViewDataSource, AddChoreCellDelegate, AssignUserCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *choreTableView;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allChores;
@property (nonatomic, strong) NSString *userToAssign;
@property (nonatomic, strong) Chore *choreToAssign;
@property (nonatomic, retain) NSDate * currDate;
@property (nonatomic, retain) NSDateFormatter * formatter;


@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.choreTableView.delegate = self;
    self.choreTableView.dataSource = self;
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    [self fetchData];
    //date picker
    self.currDate = [NSDate date];
    
    
}

- (void) refreshDeadline{
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@", _currDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKB {
    [self.view endEditing:YES];
}

- (void)fetchData {
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
    [choreQuery orderByDescending:@"name"];
    [choreQuery whereKey:@"defaultChore" equalTo:@"YES"];
    choreQuery.limit = 20;
    
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            self.allChores = (NSMutableArray *)posts;
            [self.choreTableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    userQuery.limit = 20;
    [userQuery whereKey:@"groupName" equalTo:self.currentGroup.name];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            
            self.userArray = (NSMutableArray *)objects;
            [self.userTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([tableView isEqual:self.choreTableView]) {
        AddChoreCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"AddChoreCell" forIndexPath:indexPath];
        [choreCell setCell:self.allChores[indexPath.row]];
        choreCell.delegate = self;
        return choreCell;
    } else {
        AssignUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"AssignUserCell" forIndexPath:indexPath];
        [userCell setCell:self.userArray[indexPath.row]];
        userCell.delegate = self;
        return userCell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.choreTableView]) {
        return [self.allChores count];
    } else {
        return [self.userArray count];
    }
}


- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)selectChore:(AddChoreCell *)choreCell withChore:(Chore *)chore {
    self.choreToAssign = chore;
}

- (void)selectUser:(AssignUserCell *)userCell withUserName:(NSString *)userName {
    self.userToAssign = userName;
}

- (IBAction)saveAssignment:(id)sender {
    Chore *newChore = [Chore makeChore:self.choreToAssign.name withDescription:self.choreToAssign.info withPoints:self.choreToAssign.points withDeadline:_currDate withDefault:@"NO" withUserName:self.userToAssign withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTapDeadline:(id)sender {
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
    [self refreshDeadline];
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}
@end
