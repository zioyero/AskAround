//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAsk.h"
#import "AAPerson.h"
#import "AAAnswer.h"
#import "NSArray+OCTotallyLazy.h"


@implementation AAAsk

@dynamic aboutPerson;
@dynamic fromPerson;
@dynamic answers;
@dynamic title;
@dynamic isYesNo;
@dynamic trustees;
@dynamic deadline;

#pragma mark Initialization

- (id) initWithFromPerson:(AAPerson *)from aboutPerson:(AAPerson *)about withTitle:(NSString *)title
{
    self = [self init];
    if(self)
    {
        self.aboutPerson = about;
        self.fromPerson = from;
        self.title = title;
    }
    return self;
}

#pragma mark Ask Around

/**
* Sends this ask to the server for processing
*/
-(void)sendOut
{
    [self.fromPerson sendAsk:self];

    // Add trustees (for now only mutual friends)
    [AAPerson mutualFriendsWith:self.aboutPerson withBlock:^(NSArray * mutualFriends, NSError * error)
    {
        self.trustees = [[mutualFriends subarrayWithRange:NSMakeRange(0, MIN(10, mutualFriends.count))] asSet];
        for(AAPerson * trustee in self.trustees)
        {
            [trustee.pendingAsks addObject:self];
            [trustee saveInBackground];
        }
        [self saveInBackground];
    }];
}

- (void)addAnswer:(AAAnswer *)answer
{
    if(!self.answers)
    {
        self.answers = [[NSMutableSet alloc] init];
    }
    [self.answers addObject:answer];
    [self saveInBackground];
}

#pragma mark Parse

+(NSString *)parseClassName
{
    return @"Ask";
}




@end