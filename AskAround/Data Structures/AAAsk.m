//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAsk.h"
#import "AAPerson.h"
#import "AAAnswer.h"
#import "NSArray+OCTotallyLazy.h"
#import "FBRequestConnection.h"


@implementation AAAsk

@dynamic aboutPersonID;
@dynamic fromPersonID;
@dynamic answers;
@dynamic title;
@dynamic isYesNo;
@dynamic trustees;
@dynamic deadline;
@dynamic body;

#pragma mark Initialization

- (id)initWithTitle:(NSString *)title andBody:(NSString *)body
{
    self = [self init];
    if(self)
    {
        self.fromPersonID = [AAPerson currentUser].facebookID;
        self.body = body;
        self.title = title;
    }
    return self;
}

#pragma mark Ask Around

+ (void)sendOutAsk:(AAAsk *)ask aboutPerson:(AAPerson *)about
{
    ask.aboutPersonID = about.facebookID;
    ask.fromPersonID = [AAPerson currentUser].facebookID;
    [AAPerson mutualFriendsWith:about withBlock:^(NSArray * mutualFriends, NSError * error)
    {
        NSArray * trustees = [mutualFriends subarrayWithRange:NSMakeRange(0, MIN(5, mutualFriends.count))];
        NSMutableArray * trusteeIDs = [NSMutableArray arrayWithCapacity:trustees.count];
        for(AAPerson * trustee in trustees)
        {
            [trusteeIDs addObject:trustee.facebookID];
            [trustee wasAsked:ask];
        }

        [trusteeIDs addObject:ask.fromPersonID];
        ask.trustees = trusteeIDs;
        [ask saveInBackgroundWithBlock:^(BOOL succeed, NSError *error)
        {
            if(succeed)
            {
                [[AAPerson currentUser] sendAsk:ask];
                [about addAskAbout:ask];
                NSLog(@"Sent out ask about %@", about.name);
            }
            else
            {
                NSLog(@"Check your code, something went wrong");
            }
        }];

    }];

}

- (void)addAnswer:(AAAnswer *)answer
{
    if(!self.answers)
    {
        self.answers = [[NSMutableArray alloc] init];
    }
    [self.answers addObject:answer];
    if(self.objectId)
    {
        [self saveInBackground];
    }
    else
    {
        NSLog(@"Cannot save answer for uninitialized person. Check your code for race conditions");
    }
}

#pragma mark Parse

+(NSString *)parseClassName
{
    return @"Ask";
}




@end