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
        self.ask = ask;
    }
    return self;
}

#pragma mark Ask Around

- (void)postAnswer
{
    [self.ask addAnswer:self];
}

#pragma mark Parse

+(NSString *)parseClassName
{
    return @"AAAnswer";
}


@end