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

// DEPRICATED
//- (NSString *)createTableViewCellText {
//    return [[self.chore.userName stringByAppendingString:@" has to "] stringByAppendingString:self.chore.name];
//}

- (void)didTapChore {
    [self.delegate seeChore:self withChore:self.chore withName:self.chore.userName];
}

- (NSString *)formatDeadlineDate:(NSDate *)deadlineDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    

    NSDate *startDate = [NSDate date];
    NSDate *endDate = self.chore.deadline;
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"Days between %@ and %@ is: %ld", startDate, endDate, [components day]);
    NSInteger daysRemaining = [components day];
    if (daysRemaining < 0) {
        return @"OVERDUE";
    } else {
        NSString *days = [NSString stringWithFormat: @"%ld", daysRemaining];
        return [days stringByAppendingString:@" days remaining"];
    }
}

@end
