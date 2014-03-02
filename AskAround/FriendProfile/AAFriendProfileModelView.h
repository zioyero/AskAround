//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAMyProfileModelView.h"

@class AAPerson;

/**
* A FriendProfile ModelView encapsulates the data that we show about somebody from the user's network
*/
@interface AAFriendProfileModelView : AAMyProfileModelView

- (instancetype)initWithPerson:(AAPerson *)person;
@end