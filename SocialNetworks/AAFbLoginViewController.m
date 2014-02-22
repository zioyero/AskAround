//
// Created by Agathe Battestini on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAFbLoginViewController.h"
#import "AAPerson.h"
#import "NSArray+AskAround.h"
#import "AskAroundDefines.h"
#import <Parse/PFFacebookUtils.h>

@interface AAFbLoginViewController ()
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

    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        [self.navigationController pushViewController:[[UserDetailsViewController alloc]
//                initWithStyle:UITableViewStyleGrouped] animated:NO];

        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];

        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
        }];
    }

}

// Outlet for FBLogin button
- (IBAction) loginPressed:(id)sender
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityLogin stopAnimating]; // Hide loading indicator

        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
//            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
//          [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];

    [self.activityLogin startAnimating]; // Show loading indicator until login is finished
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