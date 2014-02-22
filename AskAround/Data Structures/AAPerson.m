//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAPerson.h"
#import "FBGraphObject.h"
#import "FBRequestConnection.h"
#import "FBRequest.h"
#import "AAAsk.h"


@implementation AAPerson

@dynamic name;
@dynamic email;
@dynamic birthday;
@dynamic username;
@dynamic pendingAsks;
@dynamic answersAbout;

#pragma mark Parse

+(NSString *)parseClassName
{
    return @"AAPerson";
}

#pragma mark Initialization

- (id)initWithFacebookID:(NSString *)facebookID
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

            }
            else
            {
                self.facebookID = facebookID;
                [self initializeWithDataFromFacebook];
            }
        }];
    }
    return self;
}


- (id)initializeWithDataFromFacebook
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


        NSLog(@"Saving Email(%@) for %@", self.email, self.name);
        [self saveInBackground];
    }];

    return self;
}


#pragma mark AskAround

-(void) sendAsk:(AAAsk *)ask
{
    [self.pendingAsks addObject:ask];
    [self saveInBackground];
}



#pragma mark Facebook Helpers

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
