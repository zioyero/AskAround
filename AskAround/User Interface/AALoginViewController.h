//
// Created by Adrian Castillejos on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAAppDelegate;

@protocol AALoginViewControllerDelegate

- (void) loginSuceeded;

@end

@interface AALoginViewController : UIViewController

@property (nonatomic, weak) id<AALoginViewControllerDelegate> delegate;

@end