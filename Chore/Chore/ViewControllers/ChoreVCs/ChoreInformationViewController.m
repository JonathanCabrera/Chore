//
//  ChoreInformationViewController.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//  blash

#import "ChoreInformationViewController.h"
#import "ChoreDetailsViewController.h"
#import "ChoreInformationCell.h"
#import "AddChoreViewController.h"
#import "ChoreAssignment.h"

#import "UIScrollView+EmptyDataSet.h"

@interface ChoreInformationViewController () <UITableViewDelegate, UITableViewDataSource, ChoreInformationCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (strong, nonatomic) NSMutableArray<ChoreAssignment *> *allAssignments;
@property (strong, nonatomic) NSMutableArray<Chore *> *chores;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) NSMutableArray *userNames;

@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addChoreButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *userNameToSend;
@property (strong, nonatomic) UIColor *bgColor;

@end

@implementation ChoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

    [self fetchUserGroup];
    [self fetchChores];
    
    self.bgColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    self.view.backgroundColor = self.bgColor;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"broom"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.bgColor;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Chores";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are currently no chores to be completed at this time.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)fetchUserGroup {
    //fetch the user's group
    NSString *usersGroup = [PFUser currentUser][@"groupName"];
    self.groupNameLabel.text = usersGroup;
    if(usersGroup != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        query.limit = 1;
        [query whereKey:@"name" equalTo:usersGroup];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts != nil) {
                self.currentGroup = posts[0];
                NSLog(@"user's group: %@", self.currentGroup.name);
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
        NSLog(@"user has no group");
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    [self fetchChores];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchChores {
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 20;
    [query whereKey:@"groupName" equalTo:self.currentGroup.name];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            self.userNames = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                [self.chores addObjectsFromArray:currAssignment.uncompletedChores];
                for (Chore *currChore in currAssignment.uncompletedChores) {
                    [self.userNames addObject:currAssignment.userName];
                }
            }
            [self.tableView reloadData];
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
    Chore *myChore = self.chores[indexPath.row];
    
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
    choreQuery.limit = 1;
    [choreQuery whereKey:@"objectId" equalTo:myChore.objectId];

    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [choreCell setCell:posts[0] withName:self.userNames[indexPath.row] withColor:self.bgColor];
        } else {
            NSLog(@"nil post %@", error.localizedDescription);
        }
    }];
    
    choreCell.delegate = self;
    return choreCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chores count];
}

- (void)seeChore: (ChoreInformationCell *)cell withChore: (Chore *)chore withName:(NSString *)userName {
    self.userNameToSend = userName;
    [self performSegueWithIdentifier:@"choreDetailsSegue" sender:chore];
}

- (IBAction)didTapAddChore:(id)sender {
    [self performSegueWithIdentifier:@"addChoreSegue" sender:self.currentGroup];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *controller = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"choreDetailsSegue"]){
        ChoreDetailsViewController *detailsController = (ChoreDetailsViewController *)controller;
        detailsController.chore = sender;
        detailsController.userName = self.userNameToSend;
    } else if([segue.identifier isEqualToString:@"addChoreSegue"]) {
        AddChoreViewController *addChoreController = (AddChoreViewController *)controller.topViewController;
        addChoreController.currentGroup = sender;
    }
}

@end
