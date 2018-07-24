//
//  HomeViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "HomeViewController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse.h"
#import "ParseUI.h"
#import "CircleProgressBar.h"
#import "Group.h"
#import "Chore.h"
#import "ChoreAssignment.h"
#import "ProgressCell.h"



@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, ProgressCellDelegate>
@property (nonatomic) CGFloat progressBarWidth;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOutButton;
@property (strong, nonatomic) IBOutlet CircleProgressBar *progressBar;
@property (nonatomic) UIColor *progressBarProgressColor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIColor *progressBarTrackColor;
@property (nonatomic) CGFloat startAngle;
@property (weak, nonatomic) IBOutlet UIButton *incrementButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroProgressButton;
@property (strong, nonatomic) NSMutableArray<ChoreAssignment *> *allAssignments;
@property (strong, nonatomic) NSMutableArray<Chore *> *chores;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSMutableArray *userNames;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) long currNumberOfChores;
@property (nonatomic) long currCompletedChores;
@property (nonatomic) float increment;
@property (nonatomic, strong) UIColor *backgroundColor;

- (IBAction)onTapIncrement:(id)sender;
- (IBAction)onTapZero:(id)sender;
- (IBAction)onTapLogOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
- (IBAction)onTapProgressButton:(id)sender;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    self.view.backgroundColor = self.backgroundColor;
    [self setDesignAspects];
    
    NSString *usersGroup = [PFUser currentUser][@"groupName"];
    if(usersGroup != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        query.limit = 1;
        [query whereKey:@"name" equalTo:usersGroup];
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts != nil) {
                self.currentGroup = posts[0];
                NSLog(@"user's group: %@", self.currentGroup.name);
                [self fetchChores];
                [self fetchGroupProgress];
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
- (void) fetchChores {
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    [choreQuery whereKey:@"groupName" equalTo:self.currentGroup.name];
    choreQuery.limit = 20;
    __weak typeof(self) weakSelf = self;
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
            self.chores = [NSMutableArray array];
            for (ChoreAssignment *currAssignment in self.allAssignments) {
                if ([[PFUser currentUser].username isEqualToString:currAssignment.userName]){
                    self.currNumberOfChores += [currAssignment.uncompletedChores count] + [currAssignment.completedChores count];
                    self.currCompletedChores += [currAssignment.completedChores count];
                    self.increment = (float) self.currCompletedChores/self.currNumberOfChores;
                    [self.progressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
                        return [NSString stringWithFormat:@"%lu / %lu chores done", weakSelf.currCompletedChores, weakSelf.currNumberOfChores];
                    }];
                    [weakSelf.progressBar setProgress:0 animated:NO];
                    [weakSelf.progressBar setProgress:self.increment animated:YES duration:2];
                }
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];}

-(void)fetchGroupProgress{
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    [choreQuery whereKey:@"groupName" equalTo:self.currentGroup.name];
    choreQuery.limit = 20;
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.allAssignments = (NSMutableArray *)posts;
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
    
    
    
//    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//    [query orderByAscending:@"username"];
//    query.limit = 10;
//    [query whereKey:@"groupName" equalTo:self.currentGroup.name];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
//        if (posts != nil) {
//            self.userNames = (NSMutableArray *)posts;
//
//        } else {
//            NSLog(@" %@", error.localizedDescription);
//        }
//    }];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDesignAspects{
    UIColor *unfinished = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    UIColor *hintColor = [UIColor colorWithRed:0.78 green:0.97 blue:0.77 alpha:1.0];
    
    [_progressBar setProgressBarProgressColor:progressColor];
    [_progressBar setProgressBarTrackColor:unfinished];
    [_progressBar setHintViewBackgroundColor:hintColor];
    _progressBar.backgroundColor = self.backgroundColor;
    [_progressBar setStartAngle:270];
    [_progressBar setHintTextFont:[UIFont fontWithName:@"Avenir Next" size:24]];
    [_progressBar setHintTextColor:unfinished];
    [_progressBar setHintViewBackgroundColor:progressColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProgressCell *progressCell = [tableView dequeueReusableCellWithIdentifier:@"progressCell" forIndexPath:indexPath];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    query.limit = 10;
    [query whereKey:@"groupName" equalTo:self.currentGroup.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil){
            [progressCell setCell:self.username withColor:self.backgroundColor];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    progressCell.delegate = self;
    return progressCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userNames count];
}

- (void)seeProgress: (ProgressCell *)cell withProgress: (UIProgressView *)progress withName: (NSString *)userName{
    self.username = userName;
}

- (IBAction)onTapProgressButton:(id)sender {
    [_progressBar setProgress:0 animated:NO];
    [_progressBar setProgress:self.increment animated:YES duration:5];
}

- (IBAction)onTapIncrement:(id)sender {
    [_progressBar setProgress:(_progressBar.progress + self.increment) animated:YES];
}
- (IBAction)onTapZero:(id)sender {
    [_progressBar setProgress:0 animated:NO];
}

- (IBAction)onTapLogOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

@end
