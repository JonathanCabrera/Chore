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
#import <STPopup/STPopup.h>
#import "CreateChoreViewController.h"

@interface AddChoreViewController () <MKDropdownMenuDelegate, MKDropdownMenuDataSource>

@property (weak, nonatomic) IBOutlet UIButton *deadlineButton;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *choreMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *userMenu;
@property (weak, nonatomic) IBOutlet UIButton *customChoreButton;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allChores;
@property (nonatomic, strong) NSString *userToAssign;
@property (nonatomic, strong) DefaultChore *choreToAssign;
@property (nonatomic, retain) NSDate * currDate;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *darkGreenColor;
@property (nonatomic, strong) UIColor *lightGreenColor;
@property (nonatomic, strong) UIColor *titleColor;

@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choreMenu.dataSource = self;
    self.choreMenu.delegate = self;
    self.userMenu.dataSource = self;
    self.userMenu.delegate = self;
    self.currDate = [NSDate date];
    
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenus)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    
    [self setLayout];
    [self fetchData];
}

- (void)setLayout {
    self.backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    self.lightGreenColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.titleColor = [UIColor colorWithRed:0.00 green:0.56 blue:0.32 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.choreMenu.backgroundColor = [UIColor whiteColor];
    self.choreMenu.layer.borderWidth = 0.8f;
    self.choreMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.choreMenu.layer.cornerRadius = 20;
    self.userMenu.backgroundColor = [UIColor whiteColor];
    self.userMenu.layer.borderWidth = 0.8f;
    self.userMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.userMenu.layer.cornerRadius = 20;
    self.customChoreButton.layer.borderWidth = 0.8f;
    self.customChoreButton.layer.cornerRadius = 20;
    self.customChoreButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.deadlineButton.layer.borderWidth = 0.8f;
    self.deadlineButton.layer.cornerRadius = 20;
    self.deadlineButton.layer.borderColor = self.darkGreenColor.CGColor;
}

- (void) refreshDeadline{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *formattedDate = [formatter stringFromDate:self.currDate];
    self.deadlineButton.titleLabel.text = [NSString stringWithFormat:@"%@", formattedDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [userQuery whereKey:@"groupName" equalTo:self.currentGroup];
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
    if([dropdownMenu isEqual:self.choreMenu]) {
        if(self.choreToAssign == nil) {
            return [[NSAttributedString alloc] initWithString:@"Select a chore"
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:self.titleColor}];
        } else {
            return [[NSAttributedString alloc] initWithString:self.choreToAssign.name
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:self.titleColor}];
        }
    } else {
        if(self.userToAssign == nil) {
            return [[NSAttributedString alloc] initWithString:@"Select a user"
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:self.titleColor}];
        } else {
            return [[NSAttributedString alloc] initWithString:self.userToAssign
                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18], NSForegroundColorAttributeName:self.titleColor}];
        }
    }
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([dropdownMenu isEqual:self.choreMenu]) {
        DefaultChore *myChore = self.allChores[row];
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@ (%d pts)", myChore.name, myChore.points]
                                               attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:15], NSForegroundColorAttributeName:self.titleColor}];
    } else {
        PFUser *myUser = self.userArray[row];
        return [[NSAttributedString alloc] initWithString:myUser.username
                                               attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:15], NSForegroundColorAttributeName:self.titleColor}];
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
    return self.lightGreenColor;
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
