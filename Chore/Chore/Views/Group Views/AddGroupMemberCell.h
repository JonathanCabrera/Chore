//
//  AddGroupMemberCell.h
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddGroupMemberCellDelegate;

@interface AddGroupMemberCell : UICollectionViewCell

@property (nonatomic, weak) id<AddGroupMemberCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end


@protocol AddGroupMemberCellDelegate

- (void)addMember:(AddGroupMemberCell *)addGroupMemberCell;

@end
