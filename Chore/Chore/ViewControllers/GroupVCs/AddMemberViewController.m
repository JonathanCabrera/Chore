//
//  AddMemberViewController.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddMemberViewController.h"
#import "AddUserCell.h"
#import <Parse/Parse.h>

@interface AddMemberViewController () <UITableViewDelegate, UITableViewDataSource, AddUserCellDelegate>

@property (strong, nonatomic) NSMutableArray *userArray;
@property (weak, nonatomic) IBOutlet UILabel *yourGroupLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.yourGroupLabel.text = [NSString stringWithFormat:@"Your group: %@", self.currentGroup.name];
    [self fetchUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByDescending:@"name"];
    query.limit = 20;
    [query whereKey:@"groupName" notEqualTo:self.currentGroup.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.userArray = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AddUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddUserCell" forIndexPath:indexPath];
    [cell setCell:self.userArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userArray count];
}

- (void)selectCell:(AddUserCell *)userCell didSelect:(PFUser *)user {
    [self.currentGroup addMember:self.currentGroup withUser:user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"added user to group");
        } else {
            NSLog(@"Error adding user to group: %@", error.localizedDescription);
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
