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




@interface HomeViewController ()
@property (nonatomic) CGFloat progressBarWidth;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOutButton;
@property (strong, nonatomic) IBOutlet CircleProgressBar *progressBar;
@property (nonatomic) UIColor *progressBarProgressColor;
@property (nonatomic) UIColor *progressBarTrackColor;
@property (nonatomic) CGFloat startAngle;
@property (weak, nonatomic) IBOutlet UIButton *incrementButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroProgressButton;
@property (strong, nonatomic) NSMutableArray<ChoreAssignment *> *allAssignments;
@property (strong, nonatomic) NSMutableArray<Chore *> *chores;
@property (strong, nonatomic) ChoreAssignment *assignment;

- (IBAction)onTapIncrement:(id)sender;
- (IBAction)onTapZero:(id)sender;
- (IBAction)onTapLogOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
- (IBAction)onTapProgressButton:(id)sender;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDesignAspects];
//    [self fetchChores];
    [_progressBar setHintTextGenerationBlock:^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%.0f / 10 Chores Done", progress * self.chores.count];
    }];
}
//- (void) fetchChores {
//    PFQuery *choreQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
//    [choreQuery whereKey:@"groupName" equalTo:self.currentGroup.name];
//    choreQuery.limit = 20;
//    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
//        if (posts != nil) {
//            self.chores = (NSMutableArray *)posts;
//            self.allAssignments = (NSMutableArray *)posts;
//            for (ChoreAssignment *currAssignment in self.allAssignments) {
//                if ([[PFUser currentUser].username isEqualToString:currAssignment.userName]){
//                    [self.chores addObjectsFromArray:currAssignment.uncompletedChores];
//                    [self.chores addObjectsFromArray: currAssignment.completedChores];
//                }
//
//
//            }
//
//        } else {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDesignAspects{
    [_progressBar setProgress:100 animated:YES duration:5];
    UIColor *unfinished = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:0.46 green:0.56 blue:0.80 alpha:1.0];
    UIColor *hintColor =
    [UIColor colorWithRed:0.44 green:0.54 blue:1.00 alpha:1.0];
    UIColor *backgroundColor = [UIColor colorWithRed:0.63 green:0.87 blue:1.00 alpha:1.0];
    [_progressBar setProgressBarProgressColor:progressColor];
    [_progressBar setProgressBarTrackColor:unfinished];
    [_progressBar setHintViewBackgroundColor:hintColor];
    _progressBar.backgroundColor = backgroundColor;
    [_progressBar setStartAngle:270];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTapProgressButton:(id)sender {
    [_progressBar setProgress:0 animated:NO];
    [_progressBar setProgress:100 animated:YES duration:5];
}
- (IBAction)onTapIncrement:(id)sender {
    [_progressBar setProgress:(_progressBar.progress + 0.10f) animated:YES];
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
