//
//  ProgressCell.h
//  Chore
//
//  Created by Katie Kwan on 7/24/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"


@protocol ProgressCellDelegate;

@interface ProgressCell : UITableViewCell

@property (nonatomic, weak) id<ProgressCellDelegate> delegate;
@property (strong, nonatomic) Chore *chore;
@property (strong, nonatomic) NSString *userName;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

- (void)setCell:(NSString *)userName withColor: (UIColor *)color withProgress: (float)number withPoints: (NSNumber *)points;

@end

@protocol ProgressCellDelegate

- (void)seeMemberProfile: (ProgressCell *)cell withUser: (NSString *)userName;

@end

