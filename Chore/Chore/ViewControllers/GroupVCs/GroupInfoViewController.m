//
//  GroupInfoViewController.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "GroupMemberCell.h"
#import "AddGroupMemberCell.h"
#import "AddMemberViewController.h"
#import "ProfileViewController.h"

@interface GroupInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, AddGroupMemberCellDelegate, GroupMemberCellDelegate>


@property (strong, nonatomic) NSMutableArray *userArray;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.groupNameLabel.text = self.currentGroup.name;
    [self fetchMembers];
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    self.collectionView.backgroundColor = backgroundColor;
    self.groupNameLabel.textColor = darkGreenColor;
    
    //layout collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * (postersPerLine - 1))) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMembers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByAscending:@"username"];
    [query includeKey:@"author"];
    query.limit = 10;
    
    //get users in current group
    [query whereKey:@"groupName" equalTo:self.currentGroup.name];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.userArray = (NSMutableArray *)posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        AddGroupMemberCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddGroupMemberCell" forIndexPath:indexPath];
        [addCell setCell];
        addCell.delegate = self;
        return addCell;
    } else {
        GroupMemberCell *memberCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupMemberCell" forIndexPath:indexPath];
        [memberCell setMember:self.userArray[indexPath.row - 1]];
        memberCell.delegate = self;
        return memberCell;
    }
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.userArray count] + 1;
}

- (void)addMember:(AddGroupMemberCell *)addGroupMemberCell {
    [self performSegueWithIdentifier:@"addMember" sender:self.currentGroup];
}

- (void)seeMemberProfile:(GroupMemberCell *)cell withUser:(PFUser *)user {
    [self performSegueWithIdentifier:@"memberProfileSegue" sender:user];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nextController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"addMember"]) {
        AddMemberViewController *addMemberController = (AddMemberViewController *)nextController;
        addMemberController.currentGroup = sender;
    } else if([segue.identifier isEqualToString:@"memberProfileSegue"]) {
        ProfileViewController *profileController = (ProfileViewController *)nextController.topViewController;
        profileController.selectedUser = sender;
        profileController.showBack = YES;
    }
}






@end
