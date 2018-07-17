//
//  GroupMemberCell.h
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import <Parse/Parse.h>

@interface GroupMemberCell : UICollectionViewCell

@property (strong, nonatomic) PFUser *currUser;

@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


- (void)setMember:(PFUser *)user;

@end
