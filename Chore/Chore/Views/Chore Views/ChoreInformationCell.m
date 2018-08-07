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
    self.choreView.layer.cornerRadius = 8;
    self.choreView.layer.borderWidth = 0.7f;
    UIColor *borderColor = [UIColor colorWithRed:0.00 green:0.60 blue:0.40 alpha:1.0];
    self.choreView.layer.borderColor = borderColor.CGColor;
    self.userNameLabel.text = [self toUpperFirstChar:chore.userName];
    self.choreNameLabel.text = [self toUpperFirstChar:chore.name];
    self.pointsLabel.text  = [NSString stringWithFormat:((chore.points == 1) ? @"%d pt" : @"%d pts"), chore.points];
    if(chore.completionStatus == YES && chore[@"completedDate"] != nil) {
        self.deadlineLabel.text = [self formatCompletedDate:chore[@"completedDate"]];
    } else {
        self.deadlineLabel.text = [self formatDeadlineDate:chore.deadline];
    }
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

- (void)didTapChore {
    [self.delegate seeChore:self withChore:self.chore withName:self.chore.userName];
}

- (NSString *)formatCompletedDate:(NSDate *)completedDate {
    NSString *completedMessage = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // Month day, year
    NSString *dateString = [dateFormatter stringFromDate:completedDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *completedComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:completedDate];
    NSDateComponents *deadlineComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.chore.deadline];
    NSDate *modifiedCompleted = [calendar dateFromComponents:completedComponent];
    NSDate *modifiedDeadline = [calendar dateFromComponents:deadlineComponent];
    if([modifiedCompleted compare:modifiedDeadline] == NSOrderedDescending) {
        completedMessage = [NSString stringWithFormat:@"Completed late on %@", dateString];
        self.deadlineLabel.textColor = UIColorWithHexString(@"#b94a48");
    } else {
        completedMessage = [NSString stringWithFormat:@"Completed on %@", dateString];
        self.deadlineLabel.textColor = UIColorWithHexString(@"#468847");
    }
    return completedMessage;
}

- (NSString *)formatDeadlineDate:(NSDate *)deadlineDate {
    NSDate *startDate = [NSDate date];
    NSDate *endDate = self.chore.deadline;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger start = [gregorianCalendar component:NSCalendarUnitDay fromDate:startDate];
    NSInteger end = [gregorianCalendar component:NSCalendarUnitDay fromDate:endDate];

    NSInteger daysRemaining = end - start;
    NSString *dueMessage = @"";
    if (daysRemaining < 0) {
        dueMessage = [NSString stringWithFormat:((daysRemaining == -1) ?
                                                 @"Overdue by %ld day" :
                                                 @"Overdue by %ld days"),
                      daysRemaining * -1];
        self.deadlineLabel.textColor = UIColorWithHexString(@"#b94a48");
    } else if (daysRemaining == 0) {
        dueMessage = @"Due today";
        self.deadlineLabel.textColor = UIColorWithHexString(@"#f89406");
    } else {
        dueMessage = [NSString stringWithFormat:((daysRemaining == 1) ?
                                                 @"Due tomorrow" :
                                                 @"Due in %ld days"),
                      daysRemaining];
        self.deadlineLabel.textColor = UIColorWithHexString(@"#468847");
    }
    return dueMessage;
}

- (NSString *)toUpperFirstChar:(NSString *)text {
    return[NSString stringWithFormat:@"%@%@",
            [[text substringToIndex:1] uppercaseString],
            [[text substringFromIndex:1] lowercaseString]];
}

// From stackover flow :O so cool
static UIColor * UIColorWithHexString(NSString *hex) {
    unsigned int rgb = 0;
    [[NSScanner scannerWithString:
      [[hex uppercaseString] stringByTrimmingCharactersInSet:
       [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet]]]
     scanHexInt:&rgb];
    return [UIColor colorWithRed:((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(rgb & 0xFF)) / 255.0
                           alpha:1.0];
}


@end
