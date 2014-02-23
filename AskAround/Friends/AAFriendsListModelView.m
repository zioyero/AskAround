//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAFriendsListModelView.h"
#import "RACSignal.h"
#import "AAPerson.h"


@implementation AAFriendsListModelView {

}

-(instancetype)init {
    self = [super init];
    if (!self) return nil;

    RAC(self, friends) = [self fetchFriends];

    return self;
}

- (RACSignal *)fetchFriends
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AAPerson friendsWithBlock:^(NSArray *friends, NSError *error) {
            if(error){
                [subscriber sendError:error];
            }
            else{
                NSArray *sorted = [friends sortedArrayUsingComparator:^(AAPerson *a, AAPerson *b){
                    return [a.name compare:b.name];
                }];

                [subscriber sendNext:sorted];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

@end