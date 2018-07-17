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


@interface GroupInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *userArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchPosts];
    
    //layout collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
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

- (void)fetchPosts {
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByDescending:@"username"];
    [query includeKey:@"author"];
    query.limit = 10;
    
    //get users in current group
    [query whereKey:@"groupName" equalTo:self.groupName];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
