//
//  AddChoreCell.h
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"

@protocol AddChoreCellDelegate;

@interface AddChoreCell : UITableViewCell

@property (nonatomic, strong) Chore *chore;
@property (nonatomic, weak) id<AddChoreCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *choreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chorePointLabel;

- (void)setCell: (Chore *)chore;

@end


@protocol AddChoreCellDelegate

- (void) selectChore: (AddChoreCell *)choreCell withChore: (Chore *)chore;
@end
