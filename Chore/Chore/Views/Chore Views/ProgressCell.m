//
//  ProgressCell.m
//  Chore
//
//  Created by Katie Kwan on 7/24/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ProgressCell.h"

@implementation ProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(NSString *)userName withColor: (UIColor *)color withProgress: (float)number withPoints:(NSNumber *)points{
    _userName = userName;
    self.userNameLabel.text = self.userName;
    self.pointsLabel.text = [NSString stringWithFormat:@"%d points", [points intValue]];
    self.backgroundColor = color;
    [_progressView setProgress:number animated:YES];
}

@end
