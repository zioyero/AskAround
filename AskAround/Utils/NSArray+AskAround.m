//
// Created by Adrian Castillejos on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "NSArray+AskAround.h"


@implementation NSArray (AskAround)

- (NSArray *)arrayWithObjectsForKey:(NSString *)key
{
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:[self count]];
    for(id obj in self)
    {
        id field = [obj valueForKey:key];
        [ret addObject:field];
    }
    return ret;
}

@end