//
//  AddChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddChoreViewController.h"
#import "ChoreAssignment.h"
#import "MKDropdownMenu.h"
#import "DefaultChore.h"

@interface AddChoreViewController () <MKDropdownMenuDelegate, MKDropdownMenuDataSource>

@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *choreMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *userMenu;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allChores;
@property (nonatomic, strong) NSString *userToAssign;
@property (nonatomic, strong) DefaultChore *choreToAssign;
@property (nonatomic, retain) NSDate * currDate;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *darkGreenColor;
@property (nonatomic, strong) UIColor *lightGreenColor;

@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choreMenu.dataSource = self;
    self.choreMenu.delegate = self;
    self.userMenu.dataSource = self;
    self.userMenu.delegate = self;
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenus)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    //date picker
    self.currDate = [NSDate date];

    self.backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    self.lightGreenColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = self.backgroundColor;
    self.choreMenu.backgroundColor = self.backgroundColor;
    self.choreMenu.layer.borderWidth = 0.8f;
    self.choreMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.choreMenu.layer.cornerRadius = 20;
    self.userMenu.backgroundColor = self.backgroundColor;
    self.userMenu.layer.borderWidth = 0.8f;
    self.userMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.userMenu.layer.cornerRadius = 20;
    
    [self fetchData];
}

- (void) refreshDeadline{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *formattedDate = [formatter stringFromDate:self.currDate];
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@", formattedDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"DefaultChore"];
    [choreQuery orderByDescending:@"name"];
    choreQuery.limit = 30;
    
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allChores = (NSMutableArray *)posts;
            [self.choreMenu reloadAllComponents];
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
            [self.userMenu reloadAllComponents];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    if([dropdownMenu isEqual:self.choreMenu]) {
        return [self.allChores count];
    } else {
        return [self.userArray count];
    }
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    UIColor *titleColor = [UIColor colorWithRed:0.00 green:0.56 blue:0.32 alpha:1.0];
    if([dropdownMenu isEqual:self.choreMenu]) {
        if(self.choreToAssign == nil) {
            return [[NSAttributedString alloc] initWithString:@"Select a chore"
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:titleColor}];
        } else {
            return [[NSAttributedString alloc] initWithString:self.choreToAssign.name
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:titleColor}];
        }
    } else {
        if(self.userToAssign == nil) {
            return [[NSAttributedString alloc] initWithString:@"Select a user"
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:titleColor}];
        } else {
            return [[NSAttributedString alloc] initWithString:self.userToAssign
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:titleColor}];
        }
    }
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([dropdownMenu isEqual:self.choreMenu]) {
        DefaultChore *myChore = self.allChores[row];
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@ (%d points)", myChore.name, myChore.points]
                                               attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:16], NSForegroundColorAttributeName:self.lightGreenColor}];
    } else {
        PFUser *myUser = self.userArray[row];
        return [[NSAttributedString alloc] initWithString:myUser.username
                                               attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:16], NSForegroundColorAttributeName:self.lightGreenColor}];
    }
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([dropdownMenu isEqual:self.choreMenu]) {
        self.choreToAssign = self.allChores[row];
        [self.choreMenu reloadAllComponents];
    } else {
        PFUser *myUser = self.userArray[row];
        self.userToAssign = myUser.username;
        [self.userMenu reloadAllComponents];
    }
    [self performSelector:@selector(closeMenus) withObject:nil afterDelay:0.25];
}

- (void)closeMenus {
    [self.choreMenu closeAllComponentsAnimated:YES];
    [self.userMenu closeAllComponentsAnimated:YES];
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.darkGreenColor;
}


- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAssignment:(id)sender {
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
