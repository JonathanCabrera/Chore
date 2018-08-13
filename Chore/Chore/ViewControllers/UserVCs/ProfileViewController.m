
//  ProfileViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoreInformationCellDelegate>
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upcomingTableView.delegate = self;
    self.upcomingTableView.dataSource = self;
    if(self.selectedUser == nil) {
        self.selectedUser = [PFUser currentUser];
    }
    [self setLayout];
    [self refresh];
    self.sectionTitles = [NSMutableArray new];
    [self.sectionTitles insertObject:self.overdueString atIndex:0];
    [self.sectionTitles insertObject:self.weekString atIndex:1];
    [self.sectionTitles insertObject:self.futureString atIndex:2];
}

- (void)orderChores {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSMutableArray<Chore *> *sortedEventArray = [NSMutableArray arrayWithArray:[self.upcomingChores sortedArrayUsingDescriptors:sortDescriptors]];
    self.upcomingChores = sortedEventArray;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}

- (void)countForSections {
    self.overDue = [NSMutableArray array];
    self.thisWeek = [NSMutableArray array];
    self.future = [NSMutableArray array];
    NSDate *today = [NSDate date];
    
    for (Chore *currentChore in self.upcomingChores){
        if ([self daysBetweenDate:today andDate:currentChore.deadline] < 0){
            [self.overDue addObject:currentChore];
        } else if ([self daysBetweenDate:today andDate:currentChore.deadline] < 7 && [self daysBetweenDate:today andDate:currentChore.deadline] >= 0){
            [self.thisWeek addObject:currentChore];
        } else {
            [self.future addObject:currentChore];
        }
    }
}

- (void)createSectionTitles {
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

- (void)viewDidAppear:(BOOL)animated {
    self.choreControl.selectedSegmentIndex = 0;
    [self refresh];
}

- (void)setLayout {
    self.overdueString = @"Overdue";
    self.weekString = @"This week";
    self.futureString = @"Future";
    self.upcomingTableView.rowHeight = UITableViewAutomaticDimension;
    self.upcomingTableView.tableFooterView = [UIView new];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pointsLabel.textColor = darkGreenColor;
    self.progressLabel.textColor = darkGreenColor;
    self.userNameLabel.text = [self.selectedUser.username capitalizedString];
    self.navigationItem.title = [self.selectedUser.username capitalizedString];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width /2;
    if([self.selectedUser.username isEqualToString:[PFUser currentUser].username]) {
        [self.settingsButton setValue:@NO forKeyPath:@"hidden"];
        [self.badgeView setValue:@"NO" forKey:@"hidden"];
        self.badgeView.layer.cornerRadius = 16;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBadge)];
        [self.badgeView addGestureRecognizer:recognizer];
        [self.progressLabel setValue:@"YES" forKey:@"hidden"];
    } else {
        [self.settingsButton setValue:@YES forKeyPath:@"hidden"];
        [self.badgeView setValue:@"YES" forKey:@"hidden"];
        [self.progressLabel setValue:@"NO" forKey:@"hidden"];
        self.progressLabel.text = [NSString stringWithFormat:@"%0.f%% done", self.progress*100];
    }
}

- (void)refresh {
    [self fetchChores];
    [self orderChores];
    self.profilePicture.file = self.selectedUser[@"profilePic"];
    [self.profilePicture loadInBackground];
}

- (void)fetchChores {
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    query.limit = 1;
    [query whereKey:@"userName" equalTo:self.selectedUser.username];
    [query includeKey:@"uncompletedChores"];
    [query includeKey:@"completedChores"];
    PFObject* list = [query getFirstObject];
    NSMutableArray* uncompletedChores = [list objectForKey:@"uncompletedChores"];
    NSMutableArray* completedChores = [list objectForKey:@"completedChores"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            ChoreAssignment *assignment = posts[0];
            self.numPoints = assignment.points;
            self.upcomingChores = uncompletedChores;
            self.pastChores = completedChores;
            self.pointsLabel.text = [NSString stringWithFormat:@"%d points", self.numPoints];
            [self.upcomingTableView reloadData];
            [self orderChores];
            [self countForSections];
            
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.choreControl.selectedSegmentIndex == 1) {
        return [self.pastChores count];
    } else {
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
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.choreControl.selectedSegmentIndex == 1) {
        return 1;
    } else {
        return [self.sectionTitles count];
    }
}

- (CGFloat):(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIColor *color = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    [view setBackgroundColor:color];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setTextColor:[UIColor whiteColor]];
    label.font = [UIFont fontWithName:@"Avenir" size:18];
    NSString *string;
    if(self.choreControl.selectedSegmentIndex == 1){
        string = @"Completed";
    } else {
        string =[self.sectionTitles objectAtIndex:section];
    }
    [label setText:string];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    self.upcomingTableView.contentInset = UIEdgeInsetsMake(0, 0, -25, 0);
    if(self.choreControl.selectedSegmentIndex == 0) {
        if (section == [self.sectionTitles count] - 1) {
            return 0;
        } else {
            return 25;
        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
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

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.choreControl.selectedSegmentIndex == 1) {
        ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
            choreCell.delegate = self;
            Chore *myPastChore = self.pastChores[indexPath.row];
            [choreCell setCell:myPastChore withColor:[UIColor whiteColor]];
            return choreCell;
    } else {
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
        myUpcomingChore = self.upcomingChores[actualRow];
        [choreCell setCell:myUpcomingChore withColor:[UIColor whiteColor]];
        choreCell.delegate = self;
        choreCell.deadlineLabel.hidden = NO;
        return choreCell;
    }
}

- (void)seeChore:(ChoreInformationCell *)cell withChore: (Chore *)chore withName:(NSString *)userName {
    [self performSegueWithIdentifier:@"profileToDetails" sender:chore];
}

- (IBAction)didTapControl:(id)sender {
    [self.upcomingTableView reloadData];
}

- (IBAction)didTapSettings:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (void)didTapBadge {
    [self performSegueWithIdentifier:@"badgeSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *controller = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"profileToDetails"]){
        ChoreDetailsViewController *detailsController = (ChoreDetailsViewController *)controller;
        detailsController.chore = sender;
    }
}

@end
