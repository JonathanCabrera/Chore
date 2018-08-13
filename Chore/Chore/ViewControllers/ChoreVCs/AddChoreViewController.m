//
//  AddChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddChoreViewController.h"

@interface AddChoreViewController () <UITableViewDelegate, UITableViewDataSource, AssignUserCellDelegate, AssignChoreCellDelegate, UISearchBarDelegate, RepeatChoreViewControllerDelegate, CreateCustomChoreCellDelegate>
@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choreMenu.dataSource = self;
    self.choreMenu.delegate = self;
    self.userMenu.dataSource = self;
    self.userMenu.delegate = self;
    self.choreSearchBar.delegate = self;
    self.repeating = NO;
    self.doneSaving = YES;
    self.doneCreating = NO;
    [self setLayout];
    [self fetchDefaultChores];
    [self fetchUsers];
}

- (void)setLayout {
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenus)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    [self.choreMenu setHidden:YES];
    [self.userMenu setHidden:YES];
    self.choreMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.choreMenu.backgroundColor = self.backgroundColor;
    self.choreMenu.layer.borderWidth = 0.8f;
    self.choreMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.choreMenu.layer.cornerRadius = 20;
    self.userMenu.backgroundColor = self.backgroundColor;
    self.userMenu.layer.borderWidth = 1;
    self.userMenu.layer.borderColor = self.darkGreenColor.CGColor;
    self.userMenu.layer.cornerRadius = 20;
    self.userMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.deadlineButton.layer.borderWidth = 1;
    self.deadlineButton.layer.cornerRadius = 20;
    self.deadlineButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.deadlineButton.titleLabel.numberOfLines = 1;
    self.deadlineButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.deadlineButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.selectUserButton.layer.borderWidth = 1;
    self.selectUserButton.layer.cornerRadius = 20;
    self.selectUserButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.selectUserButton.titleLabel.numberOfLines = 1;
    self.selectUserButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.selectUserButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.selectChoreButton.layer.borderWidth = 1;
    self.selectChoreButton.layer.cornerRadius = 20;
    self.selectChoreButton.layer.borderColor = self.darkGreenColor.CGColor;
    self.selectChoreButton.titleLabel.numberOfLines = 1;
    self.selectChoreButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.selectChoreButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

- (void)refreshDeadline {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *formattedStartDate = [formatter stringFromDate:self.startDate];
    if(self.repeating == NO) {
        self.deadlineButton.titleLabel.text = [NSString stringWithFormat:@"%@", formattedStartDate];
    } else {
        NSString *formattedEndDate = [formatter stringFromDate:self.endDate];
        self.deadlineButton.titleLabel.text = [NSString stringWithFormat:@"%@ to %@", formattedStartDate, formattedEndDate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchDefaultChores {
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
}

- (void)fetchUsers {
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
    [self fetchDefaultChores];
    [self.userMenu setHidden:YES];
    [self.choreMenu setHidden:NO];
}

- (IBAction)didTapSelectUser:(id)sender {
    [self.choreMenu setHidden:YES];
    [self.userMenu setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.choreMenu]) {
        long filtered = [self.filteredChores count];
        if(filtered == [self.allChores count]) {
            return filtered + 1;
        } else {
            return filtered;
        }
    } else {
        return [self.userArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.choreMenu]) {
        if([self.filteredChores count] == [self.allChores count]) {
            if(indexPath.row == 0) {
                CreateCustomChoreCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"CreateCustomChoreCell" forIndexPath:indexPath];
                customCell.delegate = self;
                return customCell;
            } else {
                AssignChoreCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"AssignChoreCell" forIndexPath:indexPath];
                [choreCell setCell:self.filteredChores[indexPath.row - 1]];
                choreCell.delegate = self;
                return choreCell;
            }
        } else {
            AssignChoreCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"AssignChoreCell" forIndexPath:indexPath];
            [choreCell setCell:self.filteredChores[indexPath.row]];
            choreCell.delegate = self;
            return choreCell;
        }
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
    [self.choreSearchBar resignFirstResponder];
    self.choreToAssign = chore;
    self.selectChoreButton.backgroundColor = self.backgroundColor;
    self.selectChoreButton.titleLabel.text = [self toUpperFirstChar:self.choreToAssign.name];
    [self performSelector:@selector(closeMenus) withObject:nil afterDelay:0.2];
}

- (void)selectUser:(AssignUserCell *)userCell withUserName:(NSString *)userName {
    self.userToAssign = userName;
    self.selectUserButton.backgroundColor = self.backgroundColor;
    self.selectUserButton.titleLabel.text = [self toUpperFirstChar:self.userToAssign];
    [self performSelector:@selector(closeMenus) withObject:nil afterDelay:0.2];
}

- (NSString *)toUpperFirstChar:(NSString *)text {
    return [NSString stringWithFormat:@"%@%@",
           [[text substringToIndex:1] uppercaseString],
           [[text substringFromIndex:1] lowercaseString]];
}

- (void)closeMenus {
    [self.choreMenu setHidden:YES];
    [self.userMenu setHidden:YES];
}

- (IBAction)didTapCancel:(id)sender {
    [self closeMenus];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)assignChore:(NSString *)name withDeadline:(NSDate *)deadline {
    PFQuery *query = [PFQuery queryWithClassName:@"Chore"];
    [query whereKey:@"name" equalTo:name];
    [query whereKey:@"deadline" equalTo:deadline];
    [query whereKey:@"userName" equalTo:self.userToAssign];
    query.limit = 1;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object != nil) {
            Chore *currentChore = (Chore *)object;
            [ChoreAssignment assignChore:currentChore withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    NSLog(@"assigned chore!");
                    self.doneSaving = YES;
                } else {
                    NSLog(@"Error assigning chore: %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)createChore:(NSDate *)deadline {
    [Chore makeChore:self.choreToAssign.name withDescription:self.choreToAssign.info withPoints:self.choreToAssign.points withDeadline:deadline withUserName:self.userToAssign withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"created chore");
            self.doneCreating = YES;
            [self assignChore:self.choreToAssign.name withDeadline:deadline];
        } else {
            NSLog(@"error creating chore: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)saveAssignment:(id)sender {
    [self closeMenus];
    if(self.startDate == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select a deadline" fromViewController:self];
        return;
    }
    if(self.userToAssign == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select a user" fromViewController:self];
        return;
    }
    if(self.choreToAssign == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select a chore" fromViewController:self];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.repeating == NO) {
        [self createChore:self.startDate];
    } else {
        NSDate *newStartDate = [NSDate new];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [NSDateComponents new];
        NSDateComponents *startComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.startDate];
        NSDateComponents *endComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.endDate];
        NSDate *modifiedStart = [calendar dateFromComponents:startComponent];
        NSDate *modifiedEnd = [calendar dateFromComponents:endComponent];
        
        while([modifiedStart compare:modifiedEnd] != NSOrderedDescending) {
            self.doneSaving = NO;
            self.doneCreating = NO;
            [self createChore:modifiedStart];
            while(self.doneCreating == NO || self.doneSaving == NO) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            }
                if([self.frequency isEqualToString:@"Daily"]) {
                    comp.day = 1;
                    newStartDate = [calendar dateByAddingComponents:comp toDate:modifiedStart options:0];
                } else {
                    comp.weekOfYear = 1;
                    newStartDate = [calendar dateByAddingComponents:comp toDate:modifiedStart options:0];
                }
                startComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newStartDate];
                modifiedStart = [calendar dateFromComponents:startComponent];
            }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self performSelector:@selector(dismissAssignView)
               withObject:(self)
               afterDelay:1.3];
}

-(void) dismissAssignView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapDeadline:(id)sender {
    [self closeMenus];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"repeatChore" bundle:nil];
    RepeatChoreViewController *repeatController = [storyboard instantiateViewControllerWithIdentifier:@"RepeatChoreViewController"];
    repeatController.delegate = self;
    repeatController.view.frame = CGRectMake(0.0, 0.0, 375, 475);
    [self lc_presentViewController:repeatController completion:nil];
}

- (void)cancel {
    [self lc_dismissViewControllerWithCompletion:nil];
}

- (void)updateDeadline:(NSDate *)startDate withEndDate:(NSDate *)endDate withFrequency:(NSString *)frequency {
    [self lc_dismissViewControllerWithCompletion:nil];
    if([frequency isEqualToString:@"Does not repeat"]) {
        self.repeating = NO;
    } else {
        self.repeating = YES;
    }
    self.startDate = startDate;
    self.endDate = endDate;
    self.frequency = frequency;
    [self refreshDeadline];
    self.deadlineButton.backgroundColor = self.backgroundColor;
}

- (void)createCustomChore {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"createChore" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateChoreViewController"]];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)]];
    [popupController presentInViewController:self];
}

- (void)didTapBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
