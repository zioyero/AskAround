//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBGraphObject;
@class FBRequest;
@class FBRequestConnection;
@class AAAsk;


@interface AAPerson : PFObject <PFSubclassing>

#pragma mark Properties

/**
* A set of AAAsks whose aboutPerson is this person
*/
@property (nonatomic, strong) NSMutableArray *asksAbout;

/**
* The set of AAAsks currently waiting to be answered by this person
*/
@property (nonatomic, strong) NSMutableArray * pendingAsks;

/**
* The set of AAAsks this person has sent
*/
@property (nonatomic, strong) NSMutableArray * sentAsks;

/**
* Facebook likes
*/
@property (nonatomic, strong) NSSet * facebookLikes;


@property (nonatomic, strong) NSDate * birthday;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * facebookID;
@property (nonatomic, copy) NSString * picture;


#pragma mark Initialization

- (id)initWithFacebookID:(NSString *)facebookID completion:(void (^)(BOOL done))completion;

- (id)initWithFacebookID:(NSString *)facebookID;

/**
* Pulls the user data fields from their facebook account.
*/
- (id)initializeWithDataFromFacebookWithCompletion:(void (^)(BOOL done))completion;

#pragma mark Ask Around

- (void)sendAsk:(AAAsk *)ask;

/**
* Adds a new ask about this person. The person would not recieve this ask, but others that browse their profile
* will be able to see them.
*/
- (void)addAskAbout:(AAAsk *)ask;


#pragma mark Friends

+ (void)mutualFriendsWith:(AAPerson *)otherPerson withBlock:(void (^)(NSArray *mutualFriends, NSError *error))block;

+ (void)friendsWithBlock:(void (^)(NSArray *friends, NSError *error))block;

- (void)friendsWithBlock:(void (^)(NSArray *friends, NSError *error))block;

#pragma mark Facebook

+ (void)findPersonWithFacebookID:(NSString *)facebookID withBlock:(void (^)(AAPerson *person, NSError *error))block;

+ (void)findPeopleWithFacebookIDs:(NSArray *)facebookIDs withBlock:(void (^)(NSArray *people, NSError *error))block;

+ (void)currentUserFacebookIDWithBlock:(void (^)(NSString *facebookID, NSError *error))block;

- (void)populateLikesWithBlock:(void (^)(NSSet *likes))block;

#pragma mark Parse

- (void)fetchPictureWithBlock:(void (^)(NSString *pictureURL, NSError *error))block;

+ (AAPerson *)currentUser;

+ (RACSignal *)fetchCurrentUser;

+ (NSString *)parseClassName;


@end
