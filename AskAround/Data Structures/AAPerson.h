//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBGraphObject;
@class FBRequest;
@class FBRequestConnection;


@interface AAPerson : PFObject <PFSubclassing>

#pragma mark Properties

/**
* A set of AAAnswers whose aboutPerson is this person
*/
@property (nonatomic, strong) NSSet * answersAbout;

/**
* The set of AAAsks currently waiting to be answered by this person
*/
@property (nonatomic, strong) NSMutableArray * pendingAsks;


@property (nonatomic, strong) NSDate * birthday;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * facebookID;


#pragma mark Initialization

- (id)initWithFacebookID:(NSString *)facebookID;

/**
* Pulls the user data fields from their facebook account.
*/
- (id)initializeWithDataFromFacebook;


#pragma mark Friends

+ (void)friendsWithBlock:(void (^)(NSArray *friends, NSError *error))block;

#pragma mark Facebook

+ (void)findPersonWithFacebookID:(NSString *)facebookID withBlock:(void (^)(AAPerson *person, NSError *error))block;

+ (void)findPeopleWithFacebookIDs:(NSArray *)facebookIDs withBlock:(void (^)(NSArray *people, NSError *error))block;

+ (void)currentUserFacebookIDWithBlock:(void (^)(NSString *facebookID, NSError *error))block;


#pragma mark Parse

+ (NSString *)parseClassName;


@end