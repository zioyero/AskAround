//
// Created by Adrian Castillejos on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AskAround)

/**
* Creates an NSArray of objects using each object's valueForKey: object
*/
- (NSArray *) arrayWithObjectsForKey:(NSString *)key;

@end