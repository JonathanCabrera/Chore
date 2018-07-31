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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ChoreInformationCell *choreCell;
@property (weak, nonatomic) IBOutlet UIProgressView *groupProgressView;
@property (nonatomic) int points;
@property (nonatomic) long totalChores;
@property (nonatomic) long choresDone;
@property (nonatomic) float memberIncrement;
<<<<<<< HEAD
@property (nonatomic) NSInteger *indexToDelete;
@property (weak, nonatomic) IBOutlet UILabel *choresDoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalChoresLabel;

=======
>>>>>>> test3


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
    self.groupName = [PFUser currentUser][@"groupName"];
    self.navigationItem.title = self.groupName;
    [self fetchChores];
    [self fetchGroupProgress];
<<<<<<< HEAD
    _groupProgressView.layer.cornerRadius = 8;
    _groupProgressView.clipsToBounds = true;
=======
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)orderChores {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"deadline"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSMutableArray<Chore *> *sortedEventArray = [NSMutableArray arrayWithArray:[self.chores
                                                   sortedArrayUsingDescriptors:sortDescriptors]];
    self.chores = sortedEventArray;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    [self orderChores];
    [refreshControl endRefreshing];
>>>>>>> test3
}

- (void)viewWillAppear:(BOOL)animated {
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

- (NSUInteger)findItemIndexToRemove:(NSMutableArray<Chore*>*)choreArray withChoreObjectId:(NSString*)removableObjectId {
    for (int i = 0; i < [choreArray count]; i++) {
        Chore *chore = choreArray[i];
        if ([chore.objectId isEqualToString:removableObjectId]) {
            return i;
        }
    }
    return -1;
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
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                for (Chore *chore in currAssignment.uncompletedChores) {
                    [chore fetchIfNeeded];
                    [self.chores addObject:chore];
                }
                [self.tableView reloadData];
            }
            [self orderChores];
            [self.tableView reloadData];
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
    Chore *myChore = self.chores[indexPath.section];
    [choreCell setCell:myChore withColor:[UIColor whiteColor]];
    choreCell.delegate = self;
    return choreCell;
}

- (void)fetchGroupProgress{
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error){
        if (posts != nil){
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                self.totalChores += [currAssignment.uncompletedChores count] + [currAssignment.completedChores count];
                self.choresDone += [currAssignment.completedChores count];
                if (self.totalChores == 0){
                    self.memberIncrement = 0;
                } else {
                    self.memberIncrement = ((float) self.choresDone)/self.totalChores;
                }
            }
            [self->_groupProgressView setProgress:self.memberIncrement animated:YES];
            self.choresDoneLabel.text = [NSString stringWithFormat:@"%.0f%% done", self.memberIncrement*100];
         
            
        }
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chores.count;
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
        PFQuery *choreAssignmentQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
        Chore *myChore = self.chores[indexPath.section];
        [myChore fetchIfNeeded];
        [choreAssignmentQuery whereKey:@"userName" equalTo: myChore.userName];
        choreAssignmentQuery.limit = 1;
        
        [choreAssignmentQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error)  {
            self.assignment = posts[0];
                NSMutableArray<Chore *> *newUncompleted = self.assignment.uncompletedChores;
                NSUInteger removeIndex = [self findItemIndexToRemove:newUncompleted withChoreObjectId:myChore.objectId];
                Chore* removedChore = newUncompleted[removeIndex];
                [removedChore fetchIfNeeded];
                [newUncompleted removeObjectAtIndex:removeIndex];
                [self.assignment setObject:newUncompleted forKey:@"uncompletedChores"];
                [self.assignment saveInBackground];
            }];
        
        PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
        choreQuery.limit = 1;
        [choreQuery whereKey:@"objectId" equalTo:myChore.objectId];
        [choreQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object != nil) {
                    [self.chores removeObjectAtIndex:indexPath.section];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation: UITableViewRowAnimationLeft];
                    [object deleteInBackground];
                    [tableView reloadData];
                }
            }];
    }
}

- (IBAction)didTapAdd:(id)sender {
    [self performSegueWithIdentifier:@"addChoreSegue" sender:self.groupName];
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
