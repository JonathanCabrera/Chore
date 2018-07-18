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


@interface GroupInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, AddGroupMemberCellDelegate>

@property (strong, nonatomic) NSMutableArray *userArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchMembers];
    
    //layout collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 3;
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
        addCell.delegate = self;
        return addCell;
        
    } else {
        
        GroupMemberCell *memberCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupMemberCell" forIndexPath:indexPath];
        [memberCell setMember:self.userArray[indexPath.row - 1]];
        return memberCell;
        
    }
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.userArray count] + 1;
    
    
}

- (void)addMember:(AddGroupMemberCell *)addGroupMemberCell {
    
    [self performSegueWithIdentifier:@"addMember" sender:self.currentGroup];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextController = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"addMember"]) {
        
        AddMemberViewController *addMemberController = (AddMemberViewController *)nextController;
        addMemberController.currentGroup = sender;
        
    }
    
    
}






@end
