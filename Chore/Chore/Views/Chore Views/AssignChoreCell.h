//
//  AssignChoreCell.h
//  Chore
//
//  Created by Alice Park on 7/30/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultChore.h"

@protocol AssignChoreCellDelegate;

@interface AssignChoreCell : UITableViewCell

@property (strong, nonatomic) DefaultChore *chore;
@property (nonatomic, weak) id<AssignChoreCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

- (void)setCell: (DefaultChore *)chore;

@end

@protocol AssignChoreCellDelegate

- (void)selectChore: (AssignChoreCell *)choreCell withChore: (DefaultChore *)chore;

@end
