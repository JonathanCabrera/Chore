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
@property (strong, nonatomic) UIColor *bgColor;
@property (nonatomic) BOOL delete;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentGroup = [PFUser currentUser][@"groupName"];
    self.navigationItem.title = self.currentGroup;
    [self fetchChores];
}

- (void)viewDidAppear:(BOOL)animated {
    [self beginRefresh];
}

- (void)seeChore:(ChoreInformationCell *)cell withChore: (Chore *)chore withName: (NSString *)userName {
    [self performSegueWithIdentifier:@"choreDetailsSegue" sender:chore];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"broom"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.bgColor;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Chores";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no chores to be completed at this time.";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)beginRefresh {
    [self fetchChores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchChores {
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 20;
    [query whereKey:@"groupName" equalTo:self.currentGroup];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                [self.chores addObjectsFromArray:currAssignment.uncompletedChores];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
    Chore *myChore = self.chores[indexPath.section];
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
    choreQuery.limit = 1;
    [choreQuery whereKey:@"objectId" equalTo:myChore.objectId];
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [choreCell setCell:posts[0] withColor:[UIColor whiteColor]];
        } else if (self.delete == YES) {
            for (PFObject *post in posts) {
                [post deleteInBackground];
            }
        } else {
            NSLog(@"nil post %@", error.localizedDescription);
            
        }
    }];
   
    choreCell.delegate = self;
    return choreCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.chores count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        self.delete = YES;
        [self.chores removeObjectAtIndex:indexPath.section];
         [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation: UITableViewRowAnimationLeft];
    }
}

- (IBAction)didTapAdd:(id)sender {
    [self performSegueWithIdentifier:@"addChoreSegue" sender:self.currentGroup];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *controller = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"choreDetailsSegue"]){
        ChoreDetailsViewController *detailsController = (ChoreDetailsViewController *)controller;
        detailsController.chore = sender;
    } else if([segue.identifier isEqualToString:@"addChoreSegue"]) {
        AddChoreViewController *addChoreController = (AddChoreViewController *)controller.topViewController;
        addChoreController.currentGroup = sender;
    }
}

@end
