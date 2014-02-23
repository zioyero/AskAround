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

static AAPerson * currentUser;

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
@dynamic location;
@dynamic employer;
@dynamic profession;

#pragma mark Current User

+(AAPerson *)currentUser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        if(currentUser == nil){
            [FBRequestConnection startWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET"
                       completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
            {
                currentUser = [[AAPerson alloc] initWithFacebookID:response[@"id"]];
                currentUser.name = response[@"name"];
            }];
        }
    });
    return currentUser;
}

+ (void)setNewCurrentUser:(AAPerson*)user
{
    currentUser = user;
}

+ (RACSignal *)fetchCurrentUser
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if(currentUser){
            [subscriber sendNext:currentUser];
            [subscriber sendCompleted];
        }
        else {
            [FBRequestConnection startWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET"
              completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
              {
                  if(!error){
                      AAPerson *me = [[AAPerson alloc] initWithFacebookID:response[@"id"]];
                      [AAPerson setNewCurrentUser:me];
                      [subscriber sendNext:me];
                      [subscriber sendCompleted];

                  }
                  else{
                      [subscriber sendError:error];
                  }
              }];
        }
        return nil;
    }];
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
                self.objectId = person.objectId;
                self.employer = person.employer;
                self.location = person.location;
                self.picture = person.picture;
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
        self.location = response[@"location"][@"name"];
        self.employer = [response[@"work"] firstObject][@"employer"][@"name"];
        self.profession = [response[@"work"] firstObject][@"position"][@"name"];

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

    if(self.objectId)
    {
        [self saveInBackground];
    }
    else
    {
        NSLog(@"Cannot save sentAsk for uninitialized person. Check your code for race conditions");
    }
}

- (void)addAskAbout:(AAAsk *)ask
{
    if(!self.asksAbout)
    {
        self.asksAbout = [[NSMutableArray alloc] init];
    }
    [self.asksAbout addObject:ask];
    if(self.objectId)
    {
        [self saveInBackground];
    }
    else
    {
        NSLog(@"Cannot save askAbout for uninitialized person. Check your code for race conditions");
    }
}

- (void)wasAsked:(AAAsk *)ask
{
    if(!self.pendingAsks)
    {
        self.pendingAsks = [[NSMutableArray alloc] init];
    }
    [self.pendingAsks addObject:ask];
    if(self.objectId)
    {
        [self saveInBackground];
    }
    else
    {
        NSLog(@"Cannot save pendingAnsk for uninitialized person. Check your code for race conditions");
    }
}

#pragma mark Facebook Helpers

+ (void)mutualFriendsWith:(AAPerson *)otherPerson withBlock:(void (^)(NSArray * mutualFriends, NSError *error))block
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"me/mutualfriends/%@", otherPerson.facebookID]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection * connection, NSDictionary * response, NSError * error)
    {
        if(!error)
        {
            NSArray * bareBones = response[@"data"];
            NSArray * facebookIDs = [bareBones map:^(NSDictionary * personDict)
            {
                return personDict[@"id"];
            }];
            [AAPerson findPeopleWithFacebookIDs:facebookIDs withBlock:^(NSArray * people, NSError * errorFind)
            {
                if(block)
                {
                   block(people, errorFind);
                }
            }];
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
            person.name = bareBonesProfile[@"name"];
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

#pragma mark - Likes

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

#pragma mark - Pictures

- (void)fetchHttpPictureWithBlockWithBlock:(void (^)(NSURL *pictureURL, NSError *error))block
{
    [self fetchPictureWithBlock:^(NSString *url, NSError *error) {
        if(!error){
            NSInteger colon = [url rangeOfString:@":"].location;
            if (colon != NSNotFound) { // wtf how would it be missing
                url = [url substringFromIndex:colon]; // strip off existing scheme
                url = [@"http" stringByAppendingString:url];
            }
            if(block)
                block([NSURL URLWithString:url], error);
        }
        else{
            if(block)
                block(nil, error);
        }
    }];
}

- (void)fetchPictureWithBlock:(void (^)(NSString *pictureURL, NSError *error))block
{
    if(self.picture)
    {
        if(block)
            block(self.picture, nil);
        return;
    }
    else{
        @weakify(self);
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/picture", self.facebookID]
                                     parameters:@{@"redirect" : @"0", @"height": @"140", @"width":@"140"}
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection * connection, id response, NSError * error)
        {
            if(response && !error)
            {
                self.picture = response[@"data"][@"url"];
                self.picture = [self.picture stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
                if(self.objectId)
                {
                    [self saveInBackground];
                }
                else
                {
                    NSLog(@"Tried to save a new person because of their picture");
                }

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
    [q includeKey:@"pendingAsks"];
    [q includeKey:@"asksAbout"];
    [q includeKey:@"sentAsks"];
    [q setCachePolicy:kPFCachePolicyCacheElseNetwork];

    [q getFirstObjectInBackgroundWithBlock:^(PFObject * per, NSError *error)
    {
        if(!error && block)
        {
            block((AAPerson*)per, error);
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
    [compoundQuery includeKey:@"pendingAsks"];
    [compoundQuery includeKey:@"asksAbout"];
    [compoundQuery includeKey:@"sentAsks"];
    [compoundQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
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

-(void)refreshWithCompletion:(void (^)(AAPerson * person, NSError * error))block
{
    PFQuery * q = [PFQuery queryWithClassName:[AAPerson parseClassName]];
    [q whereKey:AAPERSON_FACEBOOK_ID equalTo:self.facebookID];
    [q includeKey:@"pendingAsks"];
    [q includeKey:@"asksAbout"];
    [q includeKey:@"sentAsks"];

    [q getFirstObjectInBackgroundWithBlock:^(PFObject * obj, NSError * error)
    {
        NSLog(@"Refreshing %@", obj);
        AAPerson * person = (AAPerson *)obj;
        if(person)
        {
            self.name = person.name;
            self.sentAsks = person.sentAsks;
            self.pendingAsks = person.pendingAsks;
            self.asksAbout = person.asksAbout;
            self.username = person.username;
            self.birthday = person.birthday;
            self.email = person.email;
            self.objectId = person.objectId;
            self.employer = person.employer;
            self.location = person.location;
            self.picture = person.picture;
        }

        if(block)
        {
            block(person, nil);
        }
    }];
}

@end
