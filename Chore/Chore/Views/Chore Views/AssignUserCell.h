//
//  AssignUserCell.h
//  Chore
//
//  Created by Alice Park on 7/30/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoreAssignment.h"

@protocol AssignUserCellDelegate;

@interface AssignUserCell : UITableViewCell

@property (nonatomic, weak) id<AssignUserCellDelegate> delegate;
@property (strong, nonatomic) ChoreAssignment *assignment;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

- (void)setCell: (ChoreAssignment *)assignment;

@end

@protocol AssignUserCellDelegate

- (void)selectUser: (AssignUserCell *)userCell withUserName: (NSString *)userName;

@end
