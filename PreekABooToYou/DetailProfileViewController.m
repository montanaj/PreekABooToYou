//
//  DetailProfileViewController.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/4/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "DetailProfileViewController.h"
#import "User.h"

@interface DetailProfileViewController ()

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myEmail;
@property (strong, nonatomic) IBOutlet UILabel *myAddressLabel;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *myTapGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myRightSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myLeftSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myUpSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *myDownSwipeGesture;

@property (strong, nonatomic) IBOutlet UIImageView *myImageView; //the image the originally pops up (its on the originview)
@property (strong, nonatomic) IBOutlet UIView *myOverlayView;//the transparent one that you swipe up
@property (strong, nonatomic) IBOutlet UIView *myMaskView; //masks the animation transition (covers the views below it) makes it look pretty
@property (strong, nonatomic) IBOutlet UIView *myOriginView;//helps with transition, so we call self.myoriginview
@property (strong, nonatomic) IBOutlet UIView *flipView; //the flipside view (editing)

@property BOOL flipViewBOOL;
@property (nonatomic) User *currentUser;


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


-(IBAction)handleSwipes:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.currentIndex < self.allUsersArray.count -1)
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


#pragma mark -- helper methods
//if you click on the original cell, it still segues to the next screen, but unless you call display user up above, no photo displays on the new cell.
-(void)displayUser
{
        self.currentUser = self.allUsersArray[self.currentIndex];
        self.myImageView.image = [UIImage imageWithData:self.currentUser.photo];
}

@end
