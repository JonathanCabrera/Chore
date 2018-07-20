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

@interface ChoreInformationViewController () <UITableViewDelegate, UITableViewDataSource, ChoreInformationCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chores;
@property (weak, nonatomic) IBOutlet UIButton *addChoreButton;
@property (strong, nonatomic) NSMutableArray *allAssignments;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (strong, nonatomic) NSMutableArray *userNames;
@property (strong, nonatomic) NSString *userNameToSend;


@end

@implementation ChoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    //fetch the user's group
    NSString *usersGroup = [PFUser currentUser][@"groupName"];
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
    
    [self fetchChores];
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
            [choreCell setCell:posts[0] withName:self.userNames[indexPath.row]];
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
