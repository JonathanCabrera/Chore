//
//  NSObject+ProgressBarProperties.m
//  Bolts
//
//  Created by Katie Kwan on 7/25/18.
//

#import "ProgressBarProperties.h"

@implementation ProgressBarProperties

- (instancetype) initWithTrackColor:(UIColor *)trackColor
{
    if (self = [super init]) {
        _trackColor = trackColor;
    }
    return self;
}

@end
