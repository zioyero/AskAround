//
// Created by Agathe Battestini on 2/23/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAPerson;
@class AAAsk;


@interface AAAskingPersonMessageView : UIView

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) AAAsk *ask;
@property (nonatomic, strong) AAPerson *fromPerson;

@property (nonatomic, assign) CGFloat intrinsicHeight;

- (id)initWithAsk:(AAAsk *)ask andFromPerson:(AAPerson *)person;

- (void)setAsk:(AAAsk *)ask andFromPerson:(AAPerson *)person;
@end