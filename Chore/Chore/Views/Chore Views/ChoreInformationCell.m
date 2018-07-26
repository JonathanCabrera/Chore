//  ChoreInformationCell.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.

#import "ChoreInformationCell.h"

@implementation ChoreInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
}

- (void)setCell:(Chore *)chore withColor:(UIColor *)color{
    _chore = chore;
    self.userNameLabel.text = chore.userName;
    self.choreNameLabel.text = chore.name;
    self.pointsLabel.text  = [NSString stringWithFormat:((chore.points == 1) ? @"%d pt" : @"%d pts"), chore.points];
    self.deadlineLabel.text = [self formatDeadlineDate:chore.deadline];
    [self setCurrentUserImage];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapChore)];
    [self.choreView addGestureRecognizer:tapRecognizer];
    self.backgroundColor = color;
}

- (void)setCurrentUserImage {
    NSString *currentUser = self.chore.userName;
    PFQuery *choreQuery = [PFQuery queryWithClassName:@"_User"];
    [choreQuery whereKey:@"username" equalTo:currentUser];
    choreQuery.limit = 1;
    [choreQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            PFUser *user = users[0];
            self.userImageView.file = (PFFile *)user[@"profilePic"];
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/ 2;
            self.userImageView.clipsToBounds = YES;
            [self.userImageView loadInBackground];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)setDeadlineLabelColor {
    //TODO: SET COLOR FOR DUE DATES
}

- (void)didTapChore {
    [self.delegate seeChore:self withChore:self.chore withName:self.chore.userName];
}

- (NSString *)formatDeadlineDate:(NSDate *)deadlineDate {
    NSDate *startDate = [NSDate date];
    NSDate *endDate = self.chore.deadline;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSInteger daysRemaining = [components day];
    NSString *dueMessage = @"";
    if (daysRemaining < 0) {
        dueMessage = [NSString stringWithFormat: @"Overdue by %ld days", daysRemaining * -1];
        //self.deadlineLabel.textColor = INSERT_COLOR_HERE;
    } else if (daysRemaining == 0) {
        dueMessage = @"Due Today";
        //self.deadlineLabel.textColor = INSERT_COLOR_HERE;
    } else {
        dueMessage = [NSString stringWithFormat: @"Due in %ld days", daysRemaining];
        //self.deadlineLabel.textColor = INSERT_COLOR_HERE;

    }
    
    return dueMessage;
}

@end
