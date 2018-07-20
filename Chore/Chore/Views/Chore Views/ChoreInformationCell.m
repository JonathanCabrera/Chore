//
//  ChoreInformationCell.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ChoreInformationCell.h"

@implementation ChoreInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell: (Chore *)chore withName: (NSString *)userName {
    
    _chore = chore;
    _userName = userName;
    self.choreNameLabel.text = chore.name;
    self.pointsLabel.text = [NSString stringWithFormat:@"%d", chore.points];
    self.userNameLabel.text = userName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // Month day, year
    NSString *dateString = [dateFormatter stringFromDate:chore.deadline];
    self.deadlineLabel.text = dateString;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapChore)];
    [self.choreView addGestureRecognizer:tapRecognizer];
    
}

- (void)didTapChore {
    
    [self.delegate seeChore:self withChore:self.chore withName:self.userName];
    
    
}




@end
