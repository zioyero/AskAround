//
//  AAAskMessageView.m
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <GCPlaceholderTextView/GCPlaceholderTextView.h>
#import "AAAskMessageView.h"
#import "GCPlaceholderTextView.h"

@implementation AAAskMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self createViews];

    self.hasValidBody = @NO;

    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        NSString *text = (NSString*)x;
        self.hasValidBody = (text.length>5) ? @YES : @NO;
//        NSLog(@"text ?? %@", x);
    }];

    return self;
}

- (void)createViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"Message";
    [self addSubview:self.titleLabel];

    self.textView = [[GCPlaceholderTextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.placeholder = @"I need a gift idea...";
    [self addSubview:self.textView];

    NSDictionary *metrics = @{
            @"labelPad": @(24.0f),
            @"labelT": @(8.0f),
            @"messageT":@(2.0f),
            @"messageB": @(8.0f)
    };
    NSDictionary *views = @{
            @"label": self.titleLabel,
            @"message": self.textView,
    };

    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"|-(labelPad)-[label]-(labelPad)-|"
                             options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"|-(labelPad)-[message]-(labelPad)-|"
                             options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"V:|-(labelT)-[label]-(messageT)-[message]-(messageB)-|"
                             options:0 metrics:metrics views:views]];

    [self addConstraints:constraints];


}

- (BOOL)isFirstResponder {
    if([self.textView isFirstResponder])
        return YES;
    return [super isFirstResponder];
}

- (BOOL)resignFirstResponder {
    if([self.textView isFirstResponder])
        return [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

- (NSString*)messageBody
{
    return self.textView.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
