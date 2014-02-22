//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAPerson.h"
#import "FBGraphObject.h"
#import "FBRequestConnection.h"


@implementation AAPerson
{

}

#pragma mark Initialization

- (instancetype)initializeWithFacebookUser:(FBGraphObject *)user
{

    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, id results, NSError * error)
                          {
                              NSLog(@"Got friend lists!");
                          }];
    return nil;
}


#pragma mark Parse

+(NSString *)parseClassName
{
    return @"AAPerson";
}


@end