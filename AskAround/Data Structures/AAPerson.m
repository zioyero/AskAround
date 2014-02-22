//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAPerson.h"
#import "FBGraphObject.h"
#import "FBRequestConnection.h"
#import "FBRequest.h"


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

#pragma mark Facebook Helpers

/**
* Friends array is an array of AAPerson objects
*/
- (void)friendsWithBlock:(void (^)(NSArray *friends, NSError *error))block
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
            // Check for existance on the server first
            [AAPerson findPersonWithFacebookID:bareBonesProfile[@"id"] withBlock:^(AAPerson * person, NSError * queryError)
            {
                if(person)
                {
                    [ret addObject:person];
                }
                else
                {
                    // Otherwise, create them
                    AAPerson * friend = [[AAPerson alloc] init];
                    friend.facebookID = bareBonesProfile[@"id"];
                    friend.name = bareBonesProfile[@"name"];
                    [friend saveInBackground];
                    [ret addObject:friend];
                }
            }];
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

+ (void)findPersonWithFacebookID:(NSString *)facebookID withBlock:(void (^)(AAPerson * person, NSError *error))block
{
    PFQuery * q = [PFQuery queryWithClassName:[AAPerson parseClassName]];
    [q whereKey:@"facebookID" equalTo:facebookID];

    [q getFirstObjectInBackgroundWithBlock:^(PFObject * per, NSError *error)
    {
        if(!error && block)
        {
            block(per, nil);
        }
        else if(block)
        {
            block(nil, error);
        }
    }];
}

@end
