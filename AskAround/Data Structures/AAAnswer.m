//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAnswer.h"
#import "AAPerson.h"
#import "AAAsk.h"


@implementation AAAnswer

#pragma mark Initialization

- (id) initWithBody:(NSString *)body andExtra:(NSString *)extra forAsk:(AAAsk *)ask
{
    self = [self init];
    if(self)
    {
        self.answer = body;
        self.extraText = extra;
        self.askID = ask.objectId;
        self.responderID = [AAPerson currentUser].facebookID;
    }
    return self;
}

#pragma mark Ask Around

+(void)postAnswer:(AAAnswer *)answer forAsk:(AAAsk *)ask
{
    if(!answer.responderID)
    {
        answer.responderID = [AAPerson currentUser].facebookID;
    }
    [answer saveInBackgroundWithBlock:^(BOOL succeed, NSError * error)
    {
        [ask addAnswer:answer];
    }];
}

#pragma mark Parse

+(NSString *)parseClassName
{
    return @"Answer";
}


@end