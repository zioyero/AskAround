//
// Created by Adrian Castillejos on 2/21/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAPerson;


@interface AAAnswer : PFObject <PFSubclassing>


/**
* The AAPerson that wrote this AAAnswer
*/
@property (nonatomic, strong) AAPerson * fromTrustee;

/**
* The AAPerson this answer is about
*/
@property (nonatomic, strong) AAPerson * aboutPerson;



+(NSString *)parseClassName;



@end