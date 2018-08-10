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
#import "HelpPopupViewController.h"
#import <STPopup/STPopup.h>


@interface ChoreInformationViewController () <UITableViewDelegate, UITableViewDataSource, ChoreInformationCellDelegate>

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
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray<Chore *> *overDue;
@property (strong, nonatomic) NSMutableArray<Chore *> *thisWeek;
@property (strong, nonatomic) NSMutableArray<Chore *> *future;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (nonatomic) BOOL hasOverDue;
@property (nonatomic) BOOL hasThisWeek;
@property (nonatomic) BOOL hasFuture;

@property (nonatomic) NSMutableArray *sectionsCreated;

@end

@implementation ChoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.groupName = [PFUser currentUser][@"groupName"];
    self.navigationItem.title = self.groupName;
    [self fetchChores];
    _groupProgressView.layer.cornerRadius = 8;
    _groupProgressView.clipsToBounds = true;
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fetchChores) userInfo:nil repeats:YES];
    self.backgroundColor = [UIColor whiteColor];
    self.assignChoreButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.assignChoreButton.titleLabel.numberOfLines = 2;
    self.assignChoreButton.layer.cornerRadius = 16;
    self.helpButton.layer.cornerRadius = 16;
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


//working
- (void) countForSections {
    self.overDue = [NSMutableArray array];
    self.thisWeek = [NSMutableArray array];
    self.future = [NSMutableArray array];
    NSDate *today = [NSDate date];
    
    for (Chore *chore in self.chores){
        if ([self daysBetweenDate:today andDate:chore.deadline] < 0){
            [self.overDue addObject:chore];
        } else if ([self daysBetweenDate:today andDate:chore.deadline] < 7 && [self daysBetweenDate:today andDate:chore.deadline] >= 0){
            [self.thisWeek addObject:chore];
        } else {
            [self.future addObject:chore];
        }
    }
}

//WORKING
- (void) createSectionTitles {
    self.sectionTitles = [NSMutableArray new];
    if (self.overDue.count != 0) {
        [self.sectionTitles addObject:@"Overdue"];
    }
    if (self.thisWeek.count != 0) {
        [self.sectionTitles addObject:@"This week"];
    }
    if (self.future.count != 0) {
        [self.sectionTitles addObject:@"Future"];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSString *title = self.sectionTitles[0];
        if ([title isEqualToString: @"Overdue"]) {
            return self.overDue.count;
        } else if ([title isEqualToString:@"This week"]) {
            return self.thisWeek.count;
        } else if ([title isEqualToString:@"Future"]) {
            return self.future.count;
        }
    } else if (section == 1) {
        NSString *title = self.sectionTitles[1];
        if ([title isEqualToString: @"Overdue"]) {
            return self.overDue.count;
        } else if ([title isEqualToString:@"This week"]) {
            return self.thisWeek.count;
        } else if ([title isEqualToString:@"Future"]) {
            return self.future.count;
        }
    } else if (section == 2) {
        NSString *title = self.sectionTitles[2];
        if ([title isEqualToString: @"Overdue"]) {
            return self.overDue.count;
        } else if ([title isEqualToString:@"This week"]) {
            return self.thisWeek.count;
        } else if ([title isEqualToString:@"Future"]) {
            return self.future.count;
        }
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
    Chore *myUpcomingChore;
    unsigned long actualRow = 0;
    
    if(indexPath.section == 0) {
        actualRow = [self getActualRow:0 withIndexPath:indexPath];
    } else if(indexPath.section == 1) {
        actualRow = [self getActualRow:1 withIndexPath:indexPath];
    } else if(indexPath.section == 2) {
        actualRow = [self getActualRow:2 withIndexPath:indexPath];
    }
    myUpcomingChore = self.chores[actualRow];
    [choreCell setCell:myUpcomingChore withColor:self.backgroundColor];
    choreCell.delegate = self;
    choreCell.deadlineLabel.hidden = NO;
    return choreCell;
    
}
- (unsigned long)getActualRow:(unsigned long)index withIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[index];
    
    if ([title isEqualToString:@"Overdue"]) {
        return indexPath.row;
    } else if ([title isEqualToString:@"This week"]) {
        return self.overDue.count + indexPath.row;
        return indexPath.row;
    } else if ([title isEqualToString:@"Future"]) {
        return self.overDue.count + self.thisWeek.count + indexPath.row;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
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

- (NSUInteger)findItemIndexToRemove:(NSMutableArray<Chore*>*)choreArray withChoreObjectId:(NSString*)removableObjectId {
    for (int i = 0; i < [choreArray count]; i++) {
        Chore *chore = choreArray[i];
        if ([chore.objectId isEqualToString:removableObjectId]) {
            return i;
        }
    }
    return -1;
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
            [self createSectionTitles];
            
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (void)fetchGroupProgress {
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

- (void) reloadTable {
    [self fetchChores];
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 25;
}

- (CGFloat):(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIColor *color = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:color];
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
- (IBAction)onTapHelp:(id)sender {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"helpPopUp" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpPopupViewController"]];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)]];
    [popupController presentInViewController:self];

}

- (void)didTapBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
