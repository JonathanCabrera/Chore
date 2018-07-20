//
//  AddChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddChoreViewController.h"
#import "AddChoreCell.h"
#import "AssignUserCell.h"
#import "ChoreAssignment.h"

@interface AddChoreViewController () <UITableViewDelegate, UITableViewDataSource, AddChoreCellDelegate, AssignUserCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *choreTableView;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UITextField *deadlineField;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *allChores;
@property (nonatomic, strong) NSString *userToAssign;
@property (nonatomic, strong) Chore *choreToAssign;


@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.choreTableView.delegate = self;
    self.choreTableView.dataSource = self;
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    
    [self fetchData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchData {
    
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"Chore"];
    [choreQuery orderByDescending:@"name"];
    choreQuery.limit = 20;
    
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            self.allChores = (NSMutableArray *)posts;
            [self.choreTableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    //[choreQuery orderByDescending:@"points"];
    
    userQuery.limit = 20;
    [userQuery whereKey:@"groupName" equalTo:self.currentGroup.name];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            
            self.userArray = (NSMutableArray *)objects;
            [self.userTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if([tableView isEqual:self.choreTableView]) {
        
        AddChoreCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"AddChoreCell" forIndexPath:indexPath];
        [choreCell setCell:self.allChores[indexPath.row]];
        choreCell.delegate = self;
        
        return choreCell;
    } else {

        AssignUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"AssignUserCell" forIndexPath:indexPath];
        [userCell setCell:self.userArray[indexPath.row]];
        userCell.delegate = self;
        
        return userCell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.choreTableView]) {
        return [self.allChores count];
    } else {
        return [self.userArray count];
    }
}


- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)selectChore:(AddChoreCell *)choreCell withChore:(Chore *)chore {
    self.choreToAssign = chore;
}

- (void)selectUser:(AssignUserCell *)userCell withUserName:(NSString *)userName {
    self.userToAssign = userName;
}

- (IBAction)saveAssignment:(id)sender {
    
    [ChoreAssignment assignChore:self.userToAssign withChore:self.choreToAssign withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Assigned chore!");
        } else {
            NSLog(@"Error assigning chore: %@", error.localizedDescription);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
