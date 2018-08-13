//
//  HomeViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "HomeViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, ProgressCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UIColor *bgColor;

@end

@implementation HomeViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self setDesignAspects];

    self.profilePic.file = [PFUser currentUser][@"profilePic"];
    [self.profilePic loadInBackground];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfile)];
    [self.profilePic addGestureRecognizer:gestureRecognizer];
    self.currentGroup = [PFUser currentUser][@"groupName"];
    [self fetchChores];
    
    [_progressBar setProgress:0 animated:NO];
    [_progressBar setProgress:self.increment animated:YES duration:4];
  
    
}

- (void) fetchChores {
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    [choreQuery whereKey:@"groupName" equalTo:self.currentGroup];
    [choreQuery orderByAscending:@"userName"];
    choreQuery.limit = 20;
    __weak typeof(self) weakSelf = self;
    self.membersProgress = [NSMutableArray array];
    self.memberIncrementNSNum = [NSNumber new];
    self.membersPoints = [NSMutableArray array];
    self.memberPoint = [NSNumber new];
    
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            self.userNames = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                if ([[PFUser currentUser].username isEqualToString:currAssignment.userName]){
                    self.currNumberOfChores = [currAssignment.uncompletedChores count] + [currAssignment.completedChores count];
                    self.currCompletedChores = [currAssignment.completedChores count];
                    self.myUsernameLabel.text = currAssignment.userName;
                    self.myPointsLabel.text = [NSString stringWithFormat:@"%d points", currAssignment.points];
                    if(self.currNumberOfChores == 0) {
                        self.increment = 0;
                    } else {
                        self.increment = (float) self.currCompletedChores/self.currNumberOfChores;
                    }
                    if([currAssignment.uncompletedChores count] == 0 && [currAssignment.completedChores count] != 0) {
                        [self.doneView setHidden:NO];
                    }
                    [self.progressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
                        NSString *myProgress;
                        
                        if(self.currNumberOfChores == 0) {
                            myProgress = @"";
                        } else {
                            float percentage = (float) weakSelf.currCompletedChores/weakSelf.currNumberOfChores *100;
                            myProgress = [NSString stringWithFormat:@"%.0f%%", percentage];
                       
                            
                        }
                        return myProgress;
                       
                        
                        
                       
                    }];
                    
                    
                    [weakSelf.progressBar setProgress:0 animated:NO];
                    [weakSelf.progressBar setProgress:self.increment animated:YES duration:2];
                } else {
                    [self.userNames addObject:currAssignment.userName];
                    self.memberNumberOfChores = [currAssignment.uncompletedChores count] + [currAssignment.completedChores count];
                    self.memberCompletedChores = [currAssignment.completedChores count];
                    if(self.memberNumberOfChores == 0) {
                        self.memberIncrement = 0;
                    } else {
                        self.memberIncrement = (float) self.memberCompletedChores/self.memberNumberOfChores;
                    }
                    self.memberIncrementNSNum = [NSNumber numberWithFloat:self.memberIncrement];
                    [self.membersProgress addObject:self.memberIncrementNSNum];
                    self.memberPoint = [NSNumber numberWithInt:currAssignment.points];
                    [self.membersPoints addObject:self.memberPoint];
                    [self.tableView reloadData];
                    [self hideTheChoreButton];
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void) hideTheChoreButton{
    if (self.currNumberOfChores == 0){
        self.middleChoreButton.hidden = NO;
    } else {
        self.middleChoreButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.currentGroup != nil) {
        [self fetchChores];
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.bgColor;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No group members";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:20],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no other users in your group.";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:16],
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setDesignAspects{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.viewColor = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = self.viewColor.CGColor;
    self.tableView.layer.cornerRadius = 10;
    self.userView.layer.cornerRadius = 15;
    self.userView.layer.borderColor = self.viewColor.CGColor;
    self.userView.layer.borderWidth = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.doneView setHidden:YES];
    self.addChoreButton.layer.cornerRadius = 16;
    self.middleChoreButton.layer.cornerRadius = 16;
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2;
    _progressBar.backgroundColor = [UIColor whiteColor];
    [_progressBar setStartAngle:270];
    [_progressBar setHintTextFont:[UIFont fontWithName:@"Avenir Next" size:30]];
    [_progressBar setHintViewBackgroundColor:[UIColor whiteColor]];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProgressCell *progressCell = [tableView dequeueReusableCellWithIdentifier:@"progressCell" forIndexPath:indexPath];
    [progressCell setCell:self.userNames[indexPath.row] withColor:[UIColor whiteColor] withProgress:[self.membersProgress[indexPath.row] floatValue] withPoints:self.membersPoints[indexPath.row]];
    progressCell.delegate = self;
    return progressCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userNames count];
}

- (IBAction)onTapProgressButton:(id)sender {
    [_progressBar setProgress:0 animated:NO];
    [_progressBar setProgress:self.increment animated:YES duration:1];
}

- (void)seeMemberProfile: (ProgressCell *)cell withUser: (NSString *)userName withProgress:(float)progress {
    self.progressToSend = progress;
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    query.limit = 1;
    [query whereKey:@"username" equalTo:userName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts != nil) {
                [self performSegueWithIdentifier:@"profileSegue" sender:posts[0]];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
}

- (IBAction)didTapUser:(id)sender {
    self.tabBarController.selectedIndex = 2;
}

- (void)didTapProfile {
    self.tabBarController.selectedIndex = 2;
}

- (IBAction)didTapAddChore:(id)sender {
    [self performSegueWithIdentifier:@"addChoreSegue" sender:self.currentGroup];
}

- (IBAction)didTapMiddle:(id)sender {
    [self performSegueWithIdentifier:@"middle" sender:self.currentGroup];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UINavigationController *nextController = [segue destinationViewController];
     if([segue.identifier isEqualToString:@"profileSegue"]) {
         ProfileViewController *profileController = (ProfileViewController *)nextController;
         profileController.selectedUser = sender;
         profileController.progress = self.progressToSend;
     } else if([segue.identifier isEqualToString:@"addChoreSegue"] || [segue.identifier isEqualToString:@"middle"]) {
         AddChoreViewController *addChoreController = (AddChoreViewController *)nextController.topViewController;
         addChoreController.currentGroup = sender;
     }
 }

@end
