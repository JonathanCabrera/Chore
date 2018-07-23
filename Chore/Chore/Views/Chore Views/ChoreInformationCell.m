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


- (void)setCell:(Chore *)chore withName:(NSString *)userName {
    _chore = chore;
    _userName = userName;
    
    self.userNameLabel.text = userName;
    self.choreNameLabel.text = chore.name;
//    self.userNameLabel.text = [self createTableViewCellText];
    self.pointsLabel.text = [NSString stringWithFormat:@"%d", chore.points];

    self.deadlineLabel.text = [self formatDeadlineDate:chore.deadline];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapChore)];
    
    [self.choreView addGestureRecognizer:tapRecognizer];
}

- (NSString *)createTableViewCellText {
    return [[self.userName stringByAppendingString:@" has to "] stringByAppendingString:self.chore.name];
}

- (void)didTapChore {
    [self.delegate seeChore:self withChore:self.chore withName:self.userName];
}

- (NSString *)formatDeadlineDate:(NSDate *)deadlineDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // Month day, year
    NSString *dateString = [dateFormatter stringFromDate:deadlineDate];
    return dateString;
}

@end
