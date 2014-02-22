//
// Created by Agathe Battestini on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAFbLoginViewController.h"

@interface AAFbLoginViewController () <AACommsDelegate>
@property (nonatomic, strong)  UIButton *btnLogin;
@property (nonatomic, strong)  UIActivityIndicatorView *activityLogin;
@end

@implementation AAFbLoginViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnLogin.titleLabel.text = @"Login";
    self.btnLogin.backgroundColor = [UIColor lightGrayColor];
    self.btnLogin.frame = CGRectMake(0.0, 50.0, 100.0, 44.0);
    [self.btnLogin addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLogin];

    // Ensure the User is Logged out when loading this View Controller
    // Going forward, we would check the state of the current user and bypass the Login Screen
    // but here, the Login screen is an important part of the tutorial
    [PFUser logOut];
}

// Outlet for FBLogin button
- (IBAction) loginPressed:(id)sender
{
    // Disable the Login button to prevent multiple touches
    [_btnLogin setEnabled:NO];

    // Show an activity indicator
    [_activityLogin startAnimating];

    // Do the login
    [AAComms login:self];
}


- (void) commsDidLogin:(BOOL)loggedIn {
    // Re-enable the Login button
    [_btnLogin setEnabled:YES];

    // Stop the activity indicator
    [_activityLogin stopAnimating];

    // Did we login successfully ?
    if (loggedIn) {
        // Seque to the Image Wall
        [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
    } else {
        // Show error alert
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

@end