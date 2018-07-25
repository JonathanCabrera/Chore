//
//  ChoreDetailsViewController.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ChoreDetailsViewController.h"
#import "ProfileViewController.h"
#import "ChoreInformationViewController.h"
#import "ChoreAssignment.h"


@interface ChoreDetailsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;\
@property BOOL myChore;

@end

@implementation ChoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChoreDetails];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];
    [self setFinishedButtonProperties];
    self.view.backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
}

- (void)setFinishedButtonProperties {
    self.finishedButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.finishedButton.titleLabel.numberOfLines = 2;
}

- (void)viewDidAppear:(BOOL)animated {
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapFinished:(id)sender {
    [self updateCompletedChore];
    
}

+(void)presentAlertWithTitle:(NSString *)title fromViewController:(UIViewController *)parentViewController {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {// handle response here.
    }];
    [alertViewController addAction:okAction];
    [parentViewController presentViewController:alertViewController animated:YES completion:nil];
}

- (void)updateCompletedChore{
    PFQuery *pastQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    pastQuery.limit = 1;
    [pastQuery whereKey:@"userName" equalTo:self.chore.userName];
    
    [pastQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil){
            if ([[PFUser currentUser].username isEqualToString: self.chore.userName]){

                ChoreAssignment *assignment = posts[0];
                NSMutableArray<Chore *> *newUncompleted = assignment.uncompletedChores;
                NSMutableArray<Chore *> *newCompleted = assignment.completedChores;
            
                NSUInteger removeIndex = [self findItemIndexToRemove:newUncompleted withChoreObjectId:self.chore.objectId];
    
                Chore* removedChore = newUncompleted[removeIndex];
                removedChore.completionStatus = YES;
                [removedChore fetchIfNeeded];
                
                [newCompleted addObject:removedChore];
                [newUncompleted removeObjectAtIndex:removeIndex];
                
                [assignment incrementKey:@"points" byAmount:[NSNumber numberWithInt: removedChore.points]];
                [assignment setObject:newCompleted forKey:@"completedChores"];
                [assignment setObject:newUncompleted forKey:@"uncompletedChores"];
                [assignment saveInBackground];
            }
        }
    }];
}

- (NSUInteger)findItemIndexToRemove:(NSMutableArray<Chore*>*)choreArray withChoreObjectId:(NSString*)removableObjectId {
    for (int i = 0; i < [choreArray count]; i++) {
        Chore *chore = choreArray[i];
        if ([chore.objectId isEqualToString:removableObjectId]) {
            return i;
        }
    }
    return -1;
}

- (void)setChoreDetails {
    [self setCompletionStatusLabelColor];
    self.userNameLabel.text = self.chore.userName;
    self.choreNameLabel.text = self.chore.name;
    self.deadlineLabel.text = [self formatDeadlineDate:self.chore.deadline];
    self.pointLabel.text = [NSString stringWithFormat: @"%d", self.chore.points];
    self.informationLabel.text = self.chore.info;
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];
}

- (void)setCompletionStatusLabelColor {
    if (self.chore.completionStatus) {
        self.completionStatusLabel.textColor = [UIColor greenColor];
        self.completionStatusLabel.text = @"Completed";
    } else {
        self.completionStatusLabel.textColor = [UIColor redColor];
        self.completionStatusLabel.text = @"Uncompleted";
    }
}

- (NSString *)formatDeadlineDate:(NSDate *)deadlineDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // Month day, year
    NSString *dateString = [dateFormatter stringFromDate:deadlineDate];
    return dateString;
}

- (IBAction)onTapAddPic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    UIAlertController *pictureViewController = [UIAlertController alertControllerWithTitle:@"Choose a photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [pictureViewController addAction:cameraAction];
    [pictureViewController addAction:galleryAction];
    [pictureViewController addAction:cancelAction];
    [self presentViewController:pictureViewController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(1024, 768)];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photo = resizedImage;
    [self.addPictureButton setImage:resizedImage forState:UIControlStateNormal];
    if(self.photo != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.photo);
        self.chore.photo = [PFFile fileWithData:imageData];
        [self.chore saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                NSLog(@"Saved edits!");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }
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


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[PFUser currentUser].username isEqualToString: self.chore.userName]){
        [segue.identifier isEqualToString:@"segueToMain"];
     } else {
        [ChoreDetailsViewController presentAlertWithTitle:@"Error: This is not your chore to complete" fromViewController:self];
     }
 }





@end
