//
//  GroupCell.h
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@protocol GroupCellDelegate;

@interface GroupCell : UITableViewCell

@property (nonatomic, weak) id<GroupCellDelegate> delegate;
@property (strong, nonatomic) Group *currentGroup;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (void)setCell:(Group *)group;

@end

@protocol GroupCellDelegate

- (void)selectCell:(GroupCell *)groupCell didSelect:(Group *)group;

@end
