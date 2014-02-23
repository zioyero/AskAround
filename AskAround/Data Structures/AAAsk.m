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

//@dynamic aboutPersonID;
//@dynamic fromPersonID;
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
        self.aboutPersonID = about.facebookID;
        self.fromPersonID = from.facebookID;
        self.title = title;
    }
    return self;
}

#pragma mark Ask Around

+ (void)sendOutAsk:(AAAsk *)ask aboutPerson:(AAPerson *)about
{
    [AAPerson mutualFriendsWith:about withBlock:^(NSArray * mutualFriends, NSError * error)
    {
        NSArray * trustees = [mutualFriends subarrayWithRange:NSMakeRange(0, MIN(5, mutualFriends.count))];
        NSMutableArray * trusteeIDs = [NSMutableArray arrayWithCapacity:trustees.count];
        for(AAPerson * trustee in trustees)
        {
            [trusteeIDs addObject:trustee.facebookID];
            [trustee wasAsked:ask];
        }
        ask.trustees = trusteeIDs;
        [ask saveInBackground];
    }];

    [[AAPerson currentUser] sendAsk:ask];
    [about addAskAbout:ask];
    NSLog(@"Sent out ask about %@", about.name);
}

- (void)addAnswer:(AAAnswer *)answer
{
    if(!self.answers)
    {
        self.answers = [[NSMutableArray alloc] init];
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