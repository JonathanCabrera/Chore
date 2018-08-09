//
//  CreateCustomChoreCell.m
//  Broombroom
//
//  Created by Alice Park on 8/8/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "CreateCustomChoreCell.h"

@implementation CreateCustomChoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCreate)];
    [self addGestureRecognizer:gestureRecognizer];
    self.backgroundColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    self.customLabel.textColor = [UIColor colorWithRed:0.00 green:0.56 blue:0.32 alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
}

- (void)didTapCreate {
    [self.delegate createCustomChore];
}

@end
