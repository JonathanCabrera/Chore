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

@property (nonatomic) NSInteger *indexToDelete;
@property (weak, nonatomic) IBOutlet UILabel *choresDoneLabel;
//@property (weak, nonatomic) IBOutlet UILabel *totalChoresLabel;<*Chores>
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray<Chore *> *thisWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *nextWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *future;
@property (strong, nonatomic) UIColor *backgroundColor;


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
    _groupProgressView.layer.cornerRadius = 8;
    _groupProgressView.clipsToBounds = true;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
    NSString *first = @"This Week";
    NSString *second = @"Next Week";
    NSString *third = @"Future";
    self.sectionTitles = [NSMutableArray new];
    [self.sectionTitles insertObject:first atIndex:0];
    [self.sectionTitles insertObject:second atIndex:1];
    [self.sectionTitles insertObject:third atIndex:2];
    self.backgroundColor = [UIColor whiteColor];

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

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (void) countForSections{
    
    self.thisWeek = [NSMutableArray array];
    self.nextWeek = [NSMutableArray array];
    self.future = [NSMutableArray array];
    NSDate *today = [NSDate date];
    
    for (Chore *currentChore in self.chores){
        
        if ([self daysBetweenDate:today andDate:currentChore.deadline] > 7 && [self daysBetweenDate:today andDate:currentChore.deadline] < 14){
            [self.nextWeek addObject:currentChore];
        } else if ([self daysBetweenDate:today andDate:currentChore.deadline] < 7){
            [self.thisWeek addObject:currentChore];
        } else {
            [self.future addObject:currentChore];
        }
        
        
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self orderChores];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
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
    NSString *text = @"No chores";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:20],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no chores to be completed at this time.";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:16],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor],
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
    PFQuery* query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 20;
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query includeKey:@"uncompletedChores"];
    NSArray* list = [query findObjects];
    NSMutableArray* allUncompletedChores = [NSMutableArray array];
    for (PFObject *object in list) {
        NSArray* uncompletedChores = [object objectForKey:@"uncompletedChores"];
        [allUncompletedChores addObjectsFromArray:uncompletedChores];
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            int totalChores = 0;
            int choresDone = 0;
            float memberIncrement = 0;
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                totalChores += [currAssignment.uncompletedChores count] + [currAssignment.completedChores count];
                choresDone += [currAssignment.completedChores count];
                if (totalChores == 0){
                    memberIncrement = 0;
                } else {
                    memberIncrement = ((float) choresDone)/totalChores;
                }
            }
            for (Chore *chore in allUncompletedChores) {
                [self.chores addObject:chore];
            }
            [self.tableView reloadData];
            [self->_groupProgressView setProgress:memberIncrement animated:YES];
            self.choresDoneLabel.text = [NSString stringWithFormat:@"%.0f%% done", memberIncrement*100];
            [self orderChores];
            [self.tableView reloadData];
            [self countForSections];
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
    Chore *myUpcomingChore;
    if(indexPath.section == 0) {
        myUpcomingChore = self.chores[indexPath.row];
    } else if(indexPath.section == 1) {
        unsigned long actualRow = [self.thisWeek count] + indexPath.row;
        myUpcomingChore = self.chores[actualRow];
    } else if(indexPath.section ==2){
        unsigned long actualRow = [self.thisWeek count] + [self.nextWeek count] + indexPath.row;
        myUpcomingChore = self.chores[actualRow];
        
    } else if ([self.thisWeek count] == 0){
        
    } else if ([self.nextWeek count] == 0){
        
    } else if ([self.future count] == 0){
        
    }
    
    [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
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
                    self.memberIncrement = (float) self.choresDone/self.totalChores;
                }
                
                [self.groupProgressView setProgress:self.memberIncrement animated:YES];
                self.choresDoneLabel.text = [NSString stringWithFormat:@"%.0f%% done", self.memberIncrement*100];
            }
        }
    }];
}

-(void) reloadTable
{
    [self fetchChores];
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [UIView new];
//    [headerView setBackgroundColor:[UIColor whiteColor]];
//    return headerView;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        PFQuery *choreAssignmentQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
        Chore *myChore = self.chores[indexPath.row];
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
                [self.groupProgressView reloadInputViews];
                
            }];
        
        PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
        choreQuery.limit = 1;
        [choreQuery whereKey:@"objectId" equalTo:myChore.objectId];
        [choreQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
                if (object != nil) {
                    if(indexPath.section == 0) {
                        [self.chores removeObjectAtIndex:indexPath.row];
                        [self.thisWeek removeObjectAtIndex:indexPath.row];
                    } else if(indexPath.section == 1) {
                        unsigned long actualRow = [self.thisWeek count] + indexPath.row;
                        [self.chores removeObjectAtIndex:actualRow];
                        [self.nextWeek removeObjectAtIndex:indexPath.row];
                    } else {
                        unsigned long actualRow = [self.thisWeek count] + [self.nextWeek count] + indexPath.row;
                        [self.chores removeObjectAtIndex:actualRow];
                        [self.future removeObjectAtIndex:indexPath.row];
        
                    }
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [object deleteInBackground];
                    [tableView reloadData];
                    [self.groupProgressView reloadInputViews];
                     
                }
            
            }];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        NSInteger sectionCount;
        if (section == 0){
            sectionCount = [self.thisWeek count];
        } else if (section == 1){
            sectionCount = [self.nextWeek count];
        } else {
            sectionCount = [self.future count];
        }
        
        return sectionCount;
        
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (CGFloat):(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIColor *color = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:color];
    view.layer.cornerRadius = 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setTextColor:[UIColor whiteColor]];
    label.font = [UIFont fontWithName:@"Avenir" size:18];
    NSString *string = [self.sectionTitles objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    return view;
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

