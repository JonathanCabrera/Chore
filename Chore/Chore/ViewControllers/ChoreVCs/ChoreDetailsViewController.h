//
//  ChoreDetailsViewController.h
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"
#import "ParseUI.h"

@interface ChoreDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *choreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet PFImageView *chorePic;

@property (nonatomic, strong) Chore *chore;


@end
