//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAnswer.h"
#import "AAPerson.h"
#import "AAAsk.h"


@implementation AAAnswer

#pragma mark Initialization


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