//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAPerson.h"
#import "FBGraphObject.h"
#import "FBRequestConnection.h"
#import "FBRequest.h"
#import "AAAsk.h"
#import "NSArray+OCTotallyLazy.h"
#import "AskAroundDefines.h"
#import "FBSession.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPSessionManager.h"


@implementation AAPerson

@dynamic name;
@dynamic email;
@dynamic birthday;
@dynamic username;
@dynamic pendingAsks;
@dynamic asksAbout;
@dynamic sentAsks;
@dynamic facebookID;
@dynamic facebookLikes;
@dynamic picture;

#pragma mark Current User

+(AAPerson *)currentUser
{
    static AAPerson * currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [FBRequestConnection startWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
        {
            currentUser = [[AAPerson alloc] initWithFacebookID:response[@"id"]];
        }];
    });
    return currentUser;
}

#pragma mark Parse

+(NSString *)parseClassName
{
    return @"AAPerson";
}

#pragma mark Initialization

- (id) initWithFacebookID:(NSString *)facebookID
{
    return [self initWithFacebookID:facebookID completion:nil];
}

- (id)initWithFacebookID:(NSString *)facebookID completion:(void (^)(BOOL done))completion
{
    self = [self init];
    if(self)
    {
        self.facebookID = facebookID;
        // Check the server for this person
        [AAPerson findPersonWithFacebookID:facebookID withBlock:^(AAPerson * person, NSError * error)
        {
            if(person && !error)
            {
                self.name = person.name;
                self.sentAsks = person.sentAsks;
                self.pendingAsks = person.pendingAsks;
                self.asksAbout = person.asksAbout;
                self.username = person.username;
                self.birthday = person.birthday;
                self.email = person.email;
                if(completion)
                    completion(YES);
            }
            else
            {
                self.facebookID = facebookID;
                [self initializeWithDataFromFacebookWithCompletion:^(BOOL done)
                {
                    if(completion)
                        completion(done);
                }];
            }
        }];
    }
    return self;
}


- (id)initializeWithDataFromFacebookWithCompletion:(void (^)(BOOL done))completion
{
    if(!self.facebookID)
    {
        NSLog(@"Need facebook ID!");
        return nil;
    }
    [FBRequestConnection startWithGraphPath:self.facebookID parameters:nil HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
    {
        self.name = response[@"name"];
        self.email = response[@"email"];
        NSDateFormatter * f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"MM/dd/yyyy"];
        self.birthday = [f dateFromString:response[@"birthday"]];
        if(!self.birthday)
        {
            [f setDateFormat:@"MM/dd"];
            self.birthday = [f dateFromString:response[@"birthday"]];
        }
        self.username = response[@"username"];

        NSLog(@"Saving %@ as AAPerson to cloud", self.name);
        if(completion)
        {
            completion(YES);
        }
        [self saveInBackground];
    }];

    return self;
}


#pragma mark AskAround

/**
* Sends this ask to the server for processing
*/
-(void)sendAsk:(AAAsk *)ask
{
    if(!self.sentAsks)
    {
        self.sentAsks = [[NSMutableArray alloc] init];
    }

    [self.sentAsks addObject:ask];
    [ask.aboutPerson addAskAbout:ask];

    [ask.aboutPerson saveInBackground];
    [self saveInBackground];
}

- (void)addAskAbout:(AAAsk *)ask
{
    if(!self.asksAbout)
    {
        self.asksAbout = [[NSMutableSet alloc] init];
    }
    [self.asksAbout addObject:ask];
    [self saveInBackground];
}

#pragma mark Facebook Helpers

+ (void)mutualFriendsWith:(AAPerson *)otherPerson withBlock:(void (^)(NSArray * mutualFriends, NSError *error))block
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"me/mutualfriends/%@", otherPerson.facebookID]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
    {
        NSArray * bareBones = response[@"data"];
        NSMutableArray * ret = [[NSMutableArray alloc] initWithCapacity:[bareBones count]];
        for(NSDictionary * personDict in bareBones)
        {
            AAPerson * person = [[AAPerson alloc] initWithFacebookID:personDict[@"id"]];
            [ret addObject:person];
        }

        if(block)
        {
            block(ret, error);
        }
    }];
}


/**
* Friends array is an array of AAPerson objects
*/
+ (void)friendsWithBlock:(void (^)(NSArray *friends, NSError *error))block
{

    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, NSDictionary * response, NSError * error)
    {
        if(error)
        {
            if(block)
            {
                block(nil, error);
            }
            return;
        }

        //Turn friends into AAPerson objects
        NSMutableArray * ret = [NSMutableArray array];

        NSArray * friendBareBones = response[@"data"];
        for(NSDictionary * bareBonesProfile in friendBareBones)
        {
            AAPerson * person = [[AAPerson alloc] initWithFacebookID:bareBonesProfile[@"id"]];
            [ret addObject:person];
        }

        if(block)
        {
            block(ret, error);
        }
    }];
}

- (void)friendsWithBlock:(void (^)(NSArray * friends, NSError * error))block
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/friends", self.facebookID]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, NSDictionary * response, NSError * error)
                          {
                              if(error)
                              {
                                  if(block)
                                  {
                                      block(nil, error);
                                  }
                                  return;
                              }

                              //Turn friends into AAPerson objects
                              NSMutableArray * ret = [NSMutableArray array];

                              NSArray * friendBareBones = response[@"data"];
                              for(NSDictionary * bareBonesProfile in friendBareBones)
                              {
                                  AAPerson * person = [[AAPerson alloc] initWithFacebookID:bareBonesProfile[@"id"]];
                                  [ret addObject:person];
                              }

                              if(block)
                              {
                                  block(ret, error);
                              }
                          }];
}

+ (void)currentUserFacebookIDWithBlock:(void (^)(NSString * facebookID, NSError * error))block
{
    [FBRequestConnection startWithGraphPath:@"me"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
    {
        if(!error && block)
        {
            block(response[@"id"], nil);
        }
        else if(block)
        {
            block(nil, error);
        }
    }];
}

- (void) populateLikesWithBlock:(void (^)(NSSet * likes))block
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/likes", self.facebookID]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
    {
        NSArray * likes = response[@"data"];
        self.facebookLikes = [likes asSet];
    }];
}

- (void)fetchPictureWithBlock:(void (^)(NSString *pictureURL, NSError *error))block
{
    if(self.picture){
        if(block)
            block(self.picture, nil);
    }
    else{
        @weakify(self);
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/picture", self.facebookID]
                                     parameters:@{@"redirect" : @"0"}
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection * connection, id response, NSError * error)
        {
            if(response && !error)
            {
                self.picture = response[@"data"][@"url"];
                if(block)
                {
                    block(self.picture, error);
                }
            }


        }];

    }

}

#pragma mark Query Methods

+ (void)findPersonWithFacebookID:(NSString *)facebookID withBlock:(void (^)(AAPerson * person, NSError *error))block
{
    PFQuery * q = [PFQuery queryWithClassName:[AAPerson parseClassName]];
    [q whereKey:@"facebookID" equalTo:facebookID];

    [q getFirstObjectInBackgroundWithBlock:^(PFObject * per, NSError *error)
    {
        if(!error && block)
        {
            block((AAPerson*)per, nil);
        }
        else if(block)
        {
            block(nil, error);
        }
    }];
}

/**
* Finds the first 100 people that match on the facebook IDs.
*/
+(void)findPeopleWithFacebookIDs:(NSArray *)facebookIDs withBlock:(void (^)(NSArray * people, NSError * error))block
{
    NSMutableArray * queries = [NSMutableArray arrayWithCapacity:[facebookIDs count]];
    for(NSString * facebookID in facebookIDs)
    {
        PFQuery * q = [PFQuery queryWithClassName:[AAPerson parseClassName]];
        [q whereKey:@"facebookID" equalTo:facebookID];
        [queries addObject:q];
    }
    PFQuery * compoundQuery = [PFQuery orQueryWithSubqueries:queries];
    [compoundQuery findObjectsInBackgroundWithBlock:^(NSArray * response, NSError * error)
    {
        // response is an array of AAPerson objects
        if(!error && block)
        {
            block(response, nil);
        }
        else if(block)
        {
            block(nil, error);
        }
    }];
}

@end
