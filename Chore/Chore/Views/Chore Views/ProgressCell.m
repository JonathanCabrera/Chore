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
    //self.backgroundColor = color;
    UIColor *unfinished = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.pointsLabel.textColor = unfinished;
    self.userNameLabel.textColor = unfinished;
    [_progressView setProgress:number animated:YES];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)didTapUser {
    [self.delegate seeMemberProfile:self withUser:self.userName];
}

@end
