//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBGraphObject;


@interface AAPerson : PFObject <PFSubclassing>

#pragma mark Properties

/**
* A set of AAAnswers whose aboutPerson is this person
*/
@property (nonatomic, strong) NSSet * answersAbout;

/**
* The set of AAAsks currently waiting to be answered by this person
*/
@property (nonatomic, strong) NSSet * pendingAsks;


#pragma mark Initialization

- (instancetype) initializeWithFacebookUser:(FBGraphObject *)user;



#pragma mark Parse

+ (NSString *)parseClassName;

@end