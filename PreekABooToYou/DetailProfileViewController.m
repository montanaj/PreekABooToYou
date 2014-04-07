//
//  DetailProfileViewController.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/4/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "DetailProfileViewController.h"
#import "User.h"

@interface DetailProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


//transitional views
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UIView *myMaskView; //masks the animation transition (covers the views below it)
@property (strong, nonatomic) IBOutlet UIView *myOriginView;//helps with transition, so we call self.myoriginview (imageview is on top of it

//overlay outlets
@property (strong, nonatomic) IBOutlet UIView *myOverlayView;//the transparent one
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myEmail;
@property (strong, nonatomic) IBOutlet UILabel *myAddressLabel;
//gesture recognizers
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *myTapGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myRightSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myLeftSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myUpSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myDownSwipeGesture;

//flipside outlets
@property (strong, nonatomic) IBOutlet UIView *flipView; //the flipside view (editing)
@property (strong, nonatomic) IBOutlet UITextField *myNameEditTextField;
@property (strong, nonatomic) IBOutlet UITextField *myCellEditTextField;
@property (strong, nonatomic) IBOutlet UITextField *myEmailEditTextField;
@property (strong, nonatomic) IBOutlet UITextField *myHomeAddressEditTextField;
@property (strong, nonatomic) IBOutlet UIButton *myFriendEditButton;
@property (strong, nonatomic) IBOutlet UIButton *myCoworkerEditButton;
@property (strong, nonatomic) IBOutlet UIButton *myDeleteEditButton;
@property (strong, nonatomic) IBOutlet UIButton *myEditAddPhotoButton;

@property (strong, nonatomic) IBOutlet UIButton *myEditButton;

//content control
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) User *currentUser;
@property CGRect frameOrigin;
@property BOOL flipViewBOOL;
@property BOOL isEditModeEnabled;
@property BOOL isFriendButtonSelected;
@property BOOL isCoWorkerButtonSelected;
@property BOOL isDeleteButtonSelected;
@property (strong, nonatomic) UIColor *originalEditButtonBackgroundColor;
@property (strong, nonatomic) UIColor *originalFriendsEditButtonBackgroundColor;
@property (strong, nonatomic) UIColor *originalCoWorkersEditButtonBackgroundColor;
@property (strong, nonatomic) UIColor *originalDeleteEditButtonBackgroundColor;

@end

@implementation DetailProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayUser];
    
    self.myRightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.myLeftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    self.myDownSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    self.myUpSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
}
//enables left/right swipes to cycle through user photos
//dispables left and right swipes when upswipe to view transparent window with user info is enabled
-(IBAction)handleSwipes:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.currentIndex < self.currentUsersArray.count -1)
        {
            self.currentIndex++;
            [self displayUser];
        }
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.currentIndex > 0)
        {
            self.currentIndex--;
            [self displayUser];
        }
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        self.myOverlayView.hidden = NO;
        self.myRightSwipeGesture.enabled = NO;
        self.myLeftSwipeGesture.enabled = NO;
        self.nameLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.name];
        self.myAddressLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.address];
        self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.phoneNumber];
        self.myEmail.text = [NSString stringWithFormat:@"%@", self.currentUser.email];
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        self.myOverlayView.hidden = YES;
        self.myRightSwipeGesture.enabled = YES;
        self.myLeftSwipeGesture.enabled = YES;
    }
}
//enables flip animation to editing view via tap
-(IBAction)handleTap:(UITapGestureRecognizer *)tap
{
    if (self.flipViewBOOL)
    {
        [UIView animateWithDuration:1.0f animations:^{
            [UIView transitionFromView:self.flipView
                                toView:self.myOriginView
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            completion:nil];
        }
                         completion:^(BOOL finished)
         {
             [self.view bringSubviewToFront:self.view];
             //             self.myRightSwipeGestureRecognizer.enabled = YES;
             //             self.myLeftSwipeGestureRecognizer.enabled = YES;
             //             self.myUpSwipeGestureRecognizer.enabled = YES;
             //             self.myDownSwipeGestureRecognizer.enabled = YES;
         }];
    }
    else
    {
        [UIView animateWithDuration:1.0f animations:^{
            [UIView transitionFromView:self.myOriginView
                                toView:self.flipView
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            completion:nil];
        }
                         completion:^(BOOL finished)
         {
             
         }];
    }
    self.flipViewBOOL = !self.flipViewBOOL;
}




- (IBAction)onFriendButtonPressed:(id)sender
{
    if (!self.isFriendButtonSelected)
    {
        self.myFriendEditButton.backgroundColor = [UIColor blackColor];
        self.currentUser.isFriend = [NSNumber numberWithBool:YES];
    }
    else
    {
        self.myFriendEditButton.backgroundColor = self.originalFriendsEditButtonBackgroundColor;
        self.currentUser.isFriend = [NSNumber numberWithBool:NO];
    }
    self.isFriendButtonSelected = !self.isFriendButtonSelected;

}



- (IBAction)onCoworkerButtonPressed:(id)sender
{
    if (!self.isCoWorkerButtonSelected)
    {
        self.myCoworkerEditButton.backgroundColor = [UIColor blackColor];
        self.currentUser.isCoworker = [NSNumber numberWithBool:YES];
    }
    else
    {
        self.myCoworkerEditButton.backgroundColor = self.originalCoWorkersEditButtonBackgroundColor;
        self.currentUser.isCoworker = [NSNumber numberWithBool:NO];
    }
    self.isCoWorkerButtonSelected = !self.isCoWorkerButtonSelected;


}



- (IBAction)onDeleteButtonPressed:(id)sender
{
    if (!self.isDeleteButtonSelected)
    {
        self.myDeleteEditButton.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.myDeleteEditButton.backgroundColor = self.originalDeleteEditButtonBackgroundColor;
    }
    self.isDeleteButtonSelected = !self.isDeleteButtonSelected;


}


- (void)flipsideEditModeEnable
{
    [self.myEditButton setTitle:@"D" forState:UIControlStateNormal];
    self.myEditButton.backgroundColor = [UIColor darkGrayColor];
    self.myEditAddPhotoButton.hidden = NO;
    self.myEditAddPhotoButton.userInteractionEnabled = YES;
    self.myNameEditTextField.userInteractionEnabled = YES;
    self.myCellEditTextField.userInteractionEnabled = YES;
    self.myHomeAddressEditTextField.userInteractionEnabled = YES;
    self.myEmailEditTextField.userInteractionEnabled = YES;
    self.myNameEditTextField.textColor = [UIColor whiteColor];
    self.myCellEditTextField.textColor = [UIColor whiteColor];
    self.myHomeAddressEditTextField.textColor = [UIColor whiteColor];
    self.myEmailEditTextField.textColor = [UIColor whiteColor];
    self.myFriendEditButton.userInteractionEnabled = YES;
    self.myCoworkerEditButton.userInteractionEnabled = YES;
    self.myDeleteEditButton.userInteractionEnabled = YES;
}

- (void)flipsideEditModeDisable
{
    [self.myEditButton setTitle:@"E" forState:UIControlStateNormal];
    self.myEditButton.backgroundColor = self.originalEditButtonBackgroundColor;
    self.myEditAddPhotoButton.hidden = YES;
    self.myEditAddPhotoButton.userInteractionEnabled = NO;
    self.myNameEditTextField.userInteractionEnabled = NO;
    self.myCellEditTextField.userInteractionEnabled = NO;
    self.myHomeAddressEditTextField.userInteractionEnabled = NO;
    self.myEmailEditTextField.userInteractionEnabled = NO;
    self.myNameEditTextField.textColor = [UIColor grayColor];
    self.myCellEditTextField.textColor = [UIColor grayColor];
    self.myHomeAddressEditTextField.textColor = [UIColor grayColor];
    self.myEmailEditTextField.textColor = [UIColor grayColor];
    self.myFriendEditButton.userInteractionEnabled = NO;
    self.myCoworkerEditButton.userInteractionEnabled = NO;
    self.myDeleteEditButton.userInteractionEnabled = NO;
}

#pragma mark -- helper methods
//if you click on the original cell, it still segues to the next screen, but unless you call display user up above, no photo displays on the new cell.
- (void)displayUser
{
    self.currentUser = self.currentUsersArray[self.currentIndex];
    self.myImageView.image = [UIImage imageWithData:self.currentUser.photo];
    //flipside
    self.myNameEditTextField.userInteractionEnabled = NO;
    self.myCellEditTextField.userInteractionEnabled = NO;
    self.myHomeAddressEditTextField.userInteractionEnabled = NO;
    self.myCellEditTextField.userInteractionEnabled = NO;
    self.myEmailEditTextField.userInteractionEnabled = NO;
    self.myFriendEditButton.userInteractionEnabled = NO;
    self.myCoworkerEditButton.userInteractionEnabled = NO;
    self.myDeleteEditButton.userInteractionEnabled = NO;
    self.myNameEditTextField.textColor = [UIColor grayColor];
    self.myCellEditTextField.textColor = [UIColor grayColor];
    self.myHomeAddressEditTextField.textColor = [UIColor grayColor];
    self.myEmailEditTextField.textColor = [UIColor grayColor];
    self.myNameEditTextField.text = self.currentUser.name;
    self.myCellEditTextField.text = self.currentUser.phoneNumber;
    self.myHomeAddressEditTextField.text = self.currentUser.address;
    self.myEmailEditTextField.text = self.currentUser.email;
    self.isDeleteButtonSelected = NO;
    if (self.currentUser.isFriend.boolValue)
    {
        self.isFriendButtonSelected = YES;
        self.myFriendEditButton.backgroundColor = [UIColor blackColor];
    }
    else
    {
        self.isFriendButtonSelected = NO;
        self.myFriendEditButton.backgroundColor = self.originalFriendsEditButtonBackgroundColor;
    }
    if (self.currentUser.isCoworker.boolValue)
    {
        self.isCoWorkerButtonSelected = YES;
        self.myCoworkerEditButton.backgroundColor = [UIColor blackColor];
    }
    else
    {
        self.isCoWorkerButtonSelected = NO;
        self.myCoworkerEditButton.backgroundColor = self.originalCoWorkersEditButtonBackgroundColor;
    }
    //set buttons appropriately
}

@end
