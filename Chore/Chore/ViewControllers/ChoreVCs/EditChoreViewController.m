

//
//  EditChoreViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "EditChoreViewController.h"
#import "Parse.h"
#import "ParseUI.h"

@interface EditChoreViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation EditChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.chorePicture = editedImage;
    CGSize size = CGSizeMake(250, 250);
    self.chorePicture = [self resizeImage:self.chorePicture withSize:size];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTapPost:(id)sender {
    if (self.chorePicture != nil){
        NSData *data = UIImagePNGRepresentation(self.chorePicture);
        [PFUser currentUser][@"chorePicture"] = [PFFile fileWithData:data];
        
    }
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Saved edit!");
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)onTapTakePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}
- (IBAction)onTapCameraRoll:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
@end
