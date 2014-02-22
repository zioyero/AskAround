//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAPerson;

@interface AAAsk : PFObject <PFSubclassing>

/**
* The person that this Ask is about. When this ask is answered, the AAAnswers will be stored on this
* person's account
*/
@property (nonatomic, strong) AAPerson * aboutPerson;

/**
* The person making this ask
*/
@property (nonatomic, strong) AAPerson * fromPerson;

/**
* Set of answers
*/
@property (nonatomic, strong) NSMutableSet * answers;

/**
 * The group of people that this AAAsk will be going out to. AAnswers
 */
@property (nonatomic, strong) NSSet * trustees;

/**
* Date by which this AAAsk must be answered. After this date, the AAAsk will disappear from all of the trustee's
* pending AAAsks.
*/
@property (nonatomic, strong) NSDate * deadline;

/**
* Title of the Ask, e.g. "Does <AAPerson> like wine?"
*/
@property (nonatomic, strong) NSString * title;

/**
* Whether or not this ask can be answered by Yes/No
*/
@property (nonatomic, assign) BOOL isYesNo;

/**
* Class method required by the Parse Framework
*
* @return NSString "AAAsk"
*/
+ (NSString *)parseClassName;

@end