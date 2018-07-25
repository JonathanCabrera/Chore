//
//  NSObject+ProgressBarProperties.h
//  Chore
//
//  Created by Katie Kwan on 7/25/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CircleProgressBar.h"

@protocol ProgressBarDelegate;

@interface ProgressBarProperties: NSObject

@property (nonatomic, weak) id<ProgressBarDelegate> delegate;
@property (nonatomic) UIColor *trackColor;

- (instancetype) initWithProperties:(CircleProgressBar *)progressBar withColor:(UIColor *) trackColor;


@end

@protocol ProgressBarDelegate


@end
