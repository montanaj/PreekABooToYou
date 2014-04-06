//
//  AddUserViewController.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/5/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic) IBOutlet UIButton *myAddPhotoButton;
@property (strong, nonatomic) IBOutlet UITextField *mynameTextField;
@property (strong, nonatomic) IBOutlet UITextField *myCellNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *myEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *myAddressTextField;
@property (nonatomic) NSData *imageData;

@end

@implementation AddUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

#pragma mark -- image picker controller delegate methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.myImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageData = UIImagePNGRepresentation(self.myImageView.image);
    if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(self.myImageView.image, nil, nil, nil);
    }
    self.myAddPhotoButton.titleLabel.text = @"Edit Photo";
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
- (IBAction)onAddPhotoPressed:(id)sender
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    [self reloadInputViews];
}


@end
