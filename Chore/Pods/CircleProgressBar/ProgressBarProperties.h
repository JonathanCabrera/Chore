//
//  NSObject+ProgressBarProperties.h
//  Bolts
//
//  Created by Katie Kwan on 7/25/18.
//

#import <Foundation/Foundation.h>


@interface ProgressBarProperties : NSObject

@property (nonatomic) UIColor *trackColor;

- (instancetype) initWithTrackColor:(UIColor *)trackColor;

@end
