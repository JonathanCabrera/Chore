//
//  ChoreInformationCell.h
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"


@protocol ChoreInformationCellDelegate;

@interface ChoreInformationCell : UITableViewCell

@property (nonatomic, weak) id<ChoreInformationCellDelegate> delegate;
@property (strong, nonatomic) Chore *chore;
@property (weak, nonatomic) IBOutlet UILabel *choreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIView *choreView;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


- (void)setCell:(Chore *)chore withColor: (UIColor *)color;

@end


@protocol ChoreInformationCellDelegate

- (void)seeChore: (ChoreInformationCell *)cell withChore: (Chore *)chore withName: (NSString *)userName;

@end


    
    
    
    

