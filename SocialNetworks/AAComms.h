//
// Created by Agathe Battestini on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AACommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface AAComms : NSObject
+ (void) login:(id<AACommsDelegate>)delegate;
@end