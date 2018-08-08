//
//  ChoreDetailsViewController.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.

#import "ChoreDetailsViewController.h"
#import "ProfileViewController.h"
#import "ChoreInformationViewController.h"
#import "ChoreAssignment.h"
#import <QuartzCore/QuartzCore.h>

@interface ChoreDetailsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property BOOL myChore;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ChoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChoreDetails];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self loadChorePicture];
    [self setFinishedButtonProperties];
    self.deleteButton.layer.cornerRadius = 10;
}

- (void)setFinishedButtonProperties {
    if (!([[PFUser currentUser].username isEqualToString: self.chore.userName])){
        self.finishedButton.hidden = YES;
    }
    self.finishedButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.finishedButton.titleLabel.numberOfLines = 2;
    self.finishedButton.layer.cornerRadius = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadChorePicture];
}

- (void)loadChorePicture {
    self.chorePic.file = self.chore.photo;
    self.chorePic.layer.cornerRadius = self.chorePic.frame.size.height/ 15;
    self.chorePic.clipsToBounds = YES;
    [self.chorePic loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapFinished:(id)sender {
    [self updateCompletedChore];
}

+ (void)presentAlertWithTitle:(NSString *)title fromViewController:(UIViewController *)parentViewController {
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
                //TODO: typecast posts[0]
                ChoreAssignment *assignment = posts[0];
                NSMutableArray<Chore *> *newUncompleted = assignment.uncompletedChores;
                NSMutableArray<Chore *> *newCompleted = assignment.completedChores;
                NSUInteger removeIndex = [self findItemIndexToRemove:newUncompleted withChoreObjectId:self.chore.objectId];
                Chore* removedChore = newUncompleted[removeIndex];
                removedChore.completionStatus = YES;
                removedChore[@"completedDate"] = [NSDate date];
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

- (IBAction)onTapDelete:(id)sender {
    PFQuery *pastQuery = [PFQuery queryWithClassName:@"ChoreAssignment"];
    pastQuery.limit = 1;
    [pastQuery whereKey:@"userName" equalTo:self.chore.userName];
    [pastQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil){
                //TODO: typecast posts[0]
                ChoreAssignment *assignment = posts[0];
                NSMutableArray<Chore *> *newUncompleted = assignment.uncompletedChores;
                NSMutableArray<Chore *> *newCompleted = assignment.completedChores;
                NSUInteger removeIndex = [self findItemIndexToRemove:newUncompleted withChoreObjectId:self.chore.objectId];
                Chore* removedChore = newUncompleted[removeIndex];
                [removedChore fetchIfNeeded];
                [newCompleted addObject:removedChore];
                [newUncompleted removeObjectAtIndex:removeIndex];
                [assignment setObject:newUncompleted forKey:@"uncompletedChores"];
                [assignment saveInBackground];
            
        }
    }];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
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
    [self loadChorePicture];
}
- (void)setCompletionStatusLabelColor {
    if (self.chore.completionStatus) {
        self.completionStatusLabel.text = @"Complete";
        self.completionStatusLabel.textColor = UIColorWithHexString(@"#468847");
        self.finishedButton.hidden = YES;
    } else {
        self.completionStatusLabel.text = @"Incomplete";
        self.completionStatusLabel.textColor = UIColorWithHexString(@"#b94a48");
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
    UIImage *resizedImage = [self resizeImage:info[UIImagePickerControllerEditedImage] withSize:CGSizeMake(140, 140)];
    self.chorePic.image = resizedImage;
    if(resizedImage != nil) {
        NSData *imageData = UIImagePNGRepresentation(resizedImage);
        self.chore.photo = [PFFile fileWithData:imageData];
        [self.chore saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                NSLog(@"Saved edits!");
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }
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

// From stackover flow :O so cool
static UIColor * UIColorWithHexString(NSString *hex) {
    unsigned int rgb = 0;
    [[NSScanner scannerWithString:
      [[hex uppercaseString] stringByTrimmingCharactersInSet:
       [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet]]]
     scanHexInt:&rgb];
    return [UIColor colorWithRed:((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(rgb & 0xFF)) / 255.0
                           alpha:1.0];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[PFUser currentUser].username isEqualToString: self.chore.userName]){
        [segue.identifier isEqualToString:@"segueToMain"];
     } else {
        [ChoreDetailsViewController presentAlertWithTitle:@"Error: This is not your chore to complete" fromViewController:self];
     }
 }


@end
