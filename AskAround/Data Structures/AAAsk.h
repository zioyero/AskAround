//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAPerson;
@class AAAnswer;

@interface AAAsk : PFObject <PFSubclassing>

/**
* The person that this Ask is about. When this ask is answered, the AAAnswers will be stored on this
* person's account
*/
@property (nonatomic, weak) NSString *aboutPersonID;

/**
* The person making this ask
*/
@property (nonatomic, weak) NSString *fromPersonID;

/**
* Set of answers
*/
@property (nonatomic, strong) NSMutableArray * answers;

/**
 * The group of people that this AAAsk will be going out to. AAnswers
 */
@property (nonatomic, strong) NSArray * trustees;

/**
* Date by which this AAAsk must be answered. After this date, the AAAsk will disappear from all of the trustee's
* pending AAAsks.
*/
@property (nonatomic, strong) NSDate * deadline;

/**
* Title of the Ask, e.g. "Does <AAPerson> like wine?"
*/
@property (nonatomic, copy) NSString * title;

/**
* Whether or not this ask can be answered by Yes/No
*/
@property (nonatomic, assign) BOOL isYesNo;

#pragma mark Initialization

- (id)initWithFromPerson:(AAPerson *)from aboutPerson:(AAPerson *)about withTitle:(NSString *)title;

#pragma mark Ask Around

+ (void)sendOutAsk:(AAAsk *)ask aboutPerson:(AAPerson *)about;

/**
* Adds an AAAnswer and updates the server
*/
- (void)addAnswer:(AAAnswer *)answer;

#pragma mark Parse

/**
* Class method required by the Parse Framework
*
* @return NSString "AAAsk"
*/
+ (NSString *)parseClassName;

@end