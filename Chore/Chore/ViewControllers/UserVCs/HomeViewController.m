//
//  HomeViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, ProgressCellDelegate>

@end

@implementation HomeViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    self.tableView.layer.cornerRadius = 10;
    self.userView.layer.cornerRadius = 15;
    [self setDesignAspects];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //fetches the user's current group 
    NSString *usersGroup = [PFUser currentUser][@"groupName"];
    if(usersGroup != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        query.limit = 1;
        [query whereKey:@"name" equalTo:usersGroup];
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts != nil) {
                self.currentGroup = posts[0];
                NSLog(@"current group: %@", self.currentGroup.name);
                [self fetchChores];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
        NSLog(@"user has no group");
    }
    
    [_progressBar setProgress:0 animated:NO];
    [_progressBar setProgress:self.increment animated:YES duration:5];
}

/* This method fetches the progress of both the current user and all of the other members in that current user's group */
- (void) fetchChores {
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    [choreQuery whereKey:@"groupName" equalTo:self.currentGroup.name];
    [choreQuery orderByAscending:@"userName"];
    choreQuery.limit = 20;
    __weak typeof(self) weakSelf = self;
    self.userNames = [NSMutableArray array];
    self.membersProgress = [NSMutableArray array];
    self.memberIncrementNSNum = [NSNumber new];
    self.membersPoints = [NSMutableArray array];
    self.memberPoint = [NSNumber new];
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                if ([[PFUser currentUser].username isEqualToString:currAssignment.userName]){
                    self.currNumberOfChores = [currAssignment.uncompletedChores count] + [currAssignment.completedChores count];
                    self.currCompletedChores = [currAssignment.completedChores count];
                    if(self.currNumberOfChores == 0) {
                        self.increment = 0;
                    } else {
                        self.increment = (float) self.currCompletedChores/self.currNumberOfChores;
                    }
                    [self.progressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
                        NSString *myProgress;
                        if(self.currNumberOfChores == 0) {
                            myProgress = @"No chores yet!";
                        } else {
                            float percentage = (float) weakSelf.currCompletedChores/weakSelf.currNumberOfChores *100;
                            myProgress = [NSString stringWithFormat:@"%.0f%% done", percentage];
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
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.currentGroup != nil) {
        [self fetchChores];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* sets most of the design aspects of the Home View Controller */
- (void)setDesignAspects{
    UIColor *unfinished = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    UIColor *hintColor = [UIColor colorWithRed:0.78 green:0.97 blue:0.77 alpha:1.0];

    [_progressBar setProgressBarProgressColor:[UIColor blackColor]];
    [_progressBar setProgressBarTrackColor:unfinished];
    //[_progressBar setHintViewBackgroundColor:hintColor];
    _progressBar.backgroundColor = [UIColor clearColor];
    [_progressBar setStartAngle:270];
    [_progressBar setHintTextFont:[UIFont fontWithName:@"Avenir Next" size:18]];
    [_progressBar setHintTextColor:[UIColor whiteColor]];
    //[_progressBar setHintViewBackgroundColor:[UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0]];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProgressCell *progressCell = [tableView dequeueReusableCellWithIdentifier:@"progressCell" forIndexPath:indexPath];
    [progressCell setCell:self.userNames[indexPath.row] withColor:[UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0] withProgress:[self.membersProgress[indexPath.row] floatValue] withPoints:self.membersPoints[indexPath.row]];
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

- (IBAction)onTapLogOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

- (void)seeMemberProfile: (ProgressCell *)cell withUser: (NSString *)userName {
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

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UINavigationController *nextController = [segue destinationViewController];
     if([segue.identifier isEqualToString:@"profileSegue"]) {
         ProfileViewController *profileController = (ProfileViewController *)nextController.topViewController;
         profileController.selectedUser = sender;
     }
 }
 


@end
