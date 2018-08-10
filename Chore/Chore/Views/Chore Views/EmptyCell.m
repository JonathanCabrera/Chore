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
    [super setSelected:selected animated:animated];
}

- (void)setCell: (NSString *)text {
    self.noChoreLabel.text = text;
    self.emptyView.layer.borderWidth = 0.7f;
    UIColor *borderColor = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    self.emptyView.layer.borderColor = borderColor.CGColor;
}

@end
