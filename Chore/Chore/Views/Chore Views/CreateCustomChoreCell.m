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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
}

- (void)didTapCreate {
    [self.delegate createChore];
}

@end
