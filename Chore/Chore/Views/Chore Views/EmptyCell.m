//
//  EmptyCell.m
//  Broombroom
//
//  Created by Alice Park on 8/7/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "EmptyCell.h"

@implementation EmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
}

- (void)setCell: (NSString *)text {
    self.noChoreLabel.text = text;
}

@end
