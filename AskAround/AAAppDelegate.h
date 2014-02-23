//
//  AAAppDelegate.h
//  AskAround
//
//  Created by Adrian Castillejos on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AALoginViewController.h"

@interface AAAppDelegate : UIResponder <UIApplicationDelegate, AALoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end