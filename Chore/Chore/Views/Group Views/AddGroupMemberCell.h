//
//  AddGroupMemberCell.h
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@protocol AddGroupMemberCellDelegate;

@interface AddGroupMemberCell : UICollectionViewCell

@property (nonatomic, weak) id<AddGroupMemberCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet PFImageView *addUserImage;

- (void)setCell;

@end



@protocol AddGroupMemberCellDelegate

- (void)addMember:(AddGroupMemberCell *)addGroupMemberCell;

@end
