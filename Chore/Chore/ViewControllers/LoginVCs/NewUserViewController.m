//
//  NewUserViewController.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "NewUserViewController.h"
#import "GroupCell.h"
#import "Group.h"
#import "HomeViewController.h"
#import "ChoreAssignment.h"

@interface NewUserViewController () <UITableViewDelegate, UITableViewDataSource, GroupCellDelegate>

@property (strong, nonatomic) NSMutableArray *groupArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionTwoLabel;

@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setLayout];
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    [self fetchGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLayout {
    UIColor *backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    self.titleLabel.textColor = darkGreenColor;
    self.optionOneLabel.textColor = darkGreenColor;
    self.optionTwoLabel.textColor = darkGreenColor;
}

- (void)dismissKB {
    [self.view endEditing:YES];
}

- (void)fetchGroups {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query includeKey:@"name"];
    [query orderByDescending:@"name"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.groupArray = (NSMutableArray *)posts;
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    [cell setCell:self.groupArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groupArray count];
}

- (IBAction)didTapEnter:(id)sender {
    self.createdGroup = [Group makeGroup:self.nameField.text withCompletion:^(BOOL succeeded, NSError  * _Nullable error) {
        if (succeeded) {
            NSLog(@"Made group!");
        } else {
            NSLog(@"Error making group: %@", error.localizedDescription);
        }
    }];
    [self.createdGroup addMember:self.createdGroup withUser:[PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Added user to group");
        } else {
            NSLog(@"Error adding user to group: %@", error.localizedDescription);
        }
    }];
    
    [ChoreAssignment makeChoreAssignment:[PFUser currentUser].username withGroupName:self.createdGroup.name withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Made chore assignment");
        } else {
            NSLog(@"Error making chore assignment: %@", error.localizedDescription);
        }
    }];
    [self performSegueWithIdentifier:@"newToHomeSegue" sender:self.createdGroup];
}

- (void)selectCell:(GroupCell *)groupCell didSelect:(Group *)group {
    [ChoreAssignment makeChoreAssignment:[PFUser currentUser].username withGroupName:group.name withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Made chore assignment");
        } else {
            NSLog(@"Error making chore assignment: %@", error.localizedDescription);
        }
    }];
    [self performSegueWithIdentifier:@"newToHomeSegue" sender:group];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"newToHomeSegue"]) {
        UITabBarController *tabBar = (UITabBarController *)[segue destinationViewController];
        UINavigationController *navController = (UINavigationController *)[tabBar.viewControllers objectAtIndex:0];
        HomeViewController *homeController = (HomeViewController *)navController.topViewController;
        homeController.currentGroup = sender;
    }
}

@end
