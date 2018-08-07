//
//  EmptyCell.h
//  Broombroom
//
//  Created by Alice Park on 8/7/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noChoreLabel;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

- (void)setCell: (NSString *)text;

@end
