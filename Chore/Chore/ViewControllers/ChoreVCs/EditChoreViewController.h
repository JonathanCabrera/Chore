//
//  EditChoreViewController.h
//  Chore
//
//  Created by Katie Kwan on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditChoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIButton *takeAPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (strong, nonatomic) UIImage* chorePicture;
- (IBAction)onTapCancel:(id)sender;
- (IBAction)onTapPost:(id)sender;
- (IBAction)onTapTakePic:(id)sender;

- (IBAction)onTapCameraRoll:(id)sender;

@end
