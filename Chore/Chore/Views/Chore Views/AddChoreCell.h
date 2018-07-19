//
//  AddChoreCell.h
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"

@interface AddChoreCell : UITableViewCell

@property (nonatomic, strong) Chore *chore;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *choreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chorePointLabel;

- (void)setCell: (Chore *)chore;

@end
