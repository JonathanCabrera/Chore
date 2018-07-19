//
//  EditProfileViewController.m
//  Chore
//
//  Created by Katie Kwan on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Parse.h"
#import "ParseUI.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
- (IBAction)onTapCancelButton:(id)sender;
- (IBAction)onTapPostButton:(id)sender;



@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    //self.postImage = nil;
    self.profilePic = editedImage;
    //self.picture = editedImage;
    CGSize size = CGSizeMake(250, 250);
    self.profilePic = [self resizeImage:self.profilePic withSize:size];
    
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTapPostButton:(id)sender {
    if (self.profilePic != nil){
        NSData *data = UIImagePNGRepresentation(self.profilePic);
        [PFUser currentUser][@"profilePic"] = [PFFile fileWithData:data];
        NSLog(@"got the pic");

    }

    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Saved edit!");
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
   
}
@end
