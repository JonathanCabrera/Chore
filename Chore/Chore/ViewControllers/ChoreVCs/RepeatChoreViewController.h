//
//  RepeatChoreViewController.h
//  Chore
//
//  Created by Alice Park on 7/31/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepeatChoreViewControllerDelegate;

@interface RepeatChoreViewController : UIViewController
@property (nonatomic, weak) id<RepeatChoreViewControllerDelegate> delegate;

@end

@protocol RepeatChoreViewControllerDelegate

- (void)updateDeadline:(NSDate *)startDate withEndDate:(NSDate *)endDate withFrequency:(NSString *)frequency;

@end
