//
// Created by Adrian Castillejos on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AALoginViewController.h"
#import "NSLayoutConstraint+SimpleFormatLanguage.h"


@interface AALoginViewController ()

@property (nonatomic, strong) UIImageView * logoView;

@property (nonatomic, strong) UIButton * facebookLoginButton;

@property (nonatomic, strong) UILabel * disclaimerView;

@end

@implementation AALoginViewController
{

}

#pragma mark UIView Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Creating the logo view
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.logoView];

    // Facebook login button
    self.facebookLoginButton = [[UIButton alloc] init];
    self.facebookLoginButton.backgroundColor = [UIColor blueColor];
    self.facebookLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.facebookLoginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.facebookLoginButton];

    // Disclaimer View
    self.disclaimerView = [[UILabel alloc] init];
    self.disclaimerView.text = @"We will not post anything to your Facebook account without your permission";
    self.disclaimerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.disclaimerView];

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if(self.view.constraints.count)
    {
        [self.view removeConstraints:self.view.constraints];
    }

    UIView * logo = self.logoView;
    UIView * fbbutton = self.facebookLoginButton;
    UIView * disclaimer = self.disclaimerView;
    UIView * superview = self.view;


    NSArray * constraints = [NSLayoutConstraint constraintsWithSimpleFormat:@[@"logo.top = superview.top + 100",
                                                                              @"logo.bottom <= fbbutton - 20",
                                                                              @"logo.width = 200",
                                                                              @"logo.height = 200",
                                                                              @"logo.left = superview.left + 200",
                                                                              @"logo.right = superview.right -200",
                                                                              @"fbbutton.left >= superview.left + 100",
                                                                              @"fbbutton.right <= superview.right -100",
                                                                              @"fbbutton.height = 100",
                                                                              @"fbbutton.bottom <= disclaimer.top - 20",
                                                                              @"disclaimer.bottom <= superview.bottom - 200",
                                                                              @"disclaimer.height = 200",
                                                                              @"disclaimer.left >= fbbutton.left",
                                                                              @"disclaimer.right <= fbbuton.right"]
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(logo, fbbutton, disclaimer, superview)];
    [self.view addConstraints:constraints];
    [self.view updateConstraints];
}

- (IBAction) loginPressed:(id)sender
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [self.activityLogin stopAnimating]; // Hide loading indicator

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

//    [self.activityLogin startAnimating]; // Show loading indicator until login is finished
}


@end