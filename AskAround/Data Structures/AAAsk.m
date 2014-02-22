//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAsk.h"
#import "AAPerson.h"
#import "AAAnswer.h"


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