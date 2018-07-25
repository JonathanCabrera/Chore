//
//  NSObject+ProgressBarProperties.m
//  Chore
//
//  Created by Katie Kwan on 7/25/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressBarProperties.h"

@implementation ProgressBarProperties

- (instancetype) initWithProperties:(CircleProgressBar *)progressBar withColor:(UIColor *) trackColor{
    if (self == [super init]){
        _trackColor = trackColor;
    }
    
    return self;
}

@end
