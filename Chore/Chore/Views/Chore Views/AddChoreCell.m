//
//  AddChoreCell.m
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddChoreCell.h"

@implementation AddChoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCell: (Chore *)chore {
    
    _chore = chore;
    self.choreNameLabel.text = chore.name;
    self.chorePointLabel.text = [NSString stringWithFormat:@"%d", chore.points];
    
}

@end
