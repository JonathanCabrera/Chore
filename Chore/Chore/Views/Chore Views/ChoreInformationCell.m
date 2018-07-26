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


- (void)setCell:(Chore *)chore withColor:(UIColor *)color{
    _chore = chore;
    self.userNameLabel.text = chore.userName;
    self.choreNameLabel.text = chore.name;
    if(chore.points == 1) {
        self.pointsLabel.text = [NSString stringWithFormat:@"%d pt", chore.points];
    } else {
        self.pointsLabel.text = [NSString stringWithFormat:@"%d pts", chore.points];
    }
    self.deadlineLabel.text = [self formatDeadlineDate:chore.deadline];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapChore)];
    [self.choreView addGestureRecognizer:tapRecognizer];
    self.backgroundColor = color;
}

- (NSString *)createTableViewCellText {
    return [[self.chore.userName stringByAppendingString:@" has to "] stringByAppendingString:self.chore.name];
}

- (void)didTapChore {
    [self.delegate seeChore:self withChore:self.chore withName:self.chore.userName];
}

- (NSString *)formatDeadlineDate:(NSDate *)deadlineDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // Month day, year
    NSString *dateString = [dateFormatter stringFromDate:deadlineDate];
    return dateString;
}

@end
