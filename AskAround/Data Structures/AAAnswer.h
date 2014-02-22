//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAPerson;
@class AAAsk;


@interface AAAnswer : PFObject <PFSubclassing>

/**
* The AAPerson that wrote this AAAnswer
*/
@property (nonatomic, strong) AAPerson * fromTrustee;

/**
* The AAAsk this is an AAAnswer for
*/
@property (nonatomic, weak) AAAsk * ask;

/**
* Whether or not this is a yes or no answer.
* If YES, then the answer field contains @"YES" or @"NO"
*/
@property (nonatomic, assign) BOOL isYesNo;

/**
* The text of the answer. If this is a YES or NO question, this only contains "YES" or "NO"
*/
@property (nonatomic, assign) NSString * answer;

/**
* For yes or no questions, this contains any extra text input by the user. Otherwise, this is nil.
*/
@property (nonatomic, assign) NSString * extraText;

/**
* Adds this answer to the original ask
*/
-(void)postAnswer;



+(NSString *)parseClassName;



@end