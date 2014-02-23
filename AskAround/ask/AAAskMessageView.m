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

- (id)initWithStyle:(AAAskMessageViewStyle)style
{
    self = [super init];
    if (!self) return nil;

    [self createViews];

    self.hasValidBody = @NO;
    self.style = style;

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
    if(self.style == AAAskMessageViewStyleAsk)
        self.titleLabel.text = @"Message";
    self.titleLabel.font = [UIFont mediumFontWithSize:14.0];
    self.titleLabel.textColor = [UIColor darkerTextColor];
    [self addSubview:self.titleLabel];

    self.textView = [[GCPlaceholderTextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    if(self.style == AAAskMessageViewStyleAsk)
        self.textView.placeholder = @"I need a gift idea...";
    else if(self.style == AAAskMessageViewStyleAnswer)
        self.textView.placeholder = @"Type...";
    self.textView.placeholderColor = [UIColor lighterTextColor];
    self.textView.textColor = [UIColor lighterTextColor];
    self.textView.font = [UIFont mediumFontWithSize:16.0];
    self.textView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.textView];

    NSDictionary *metrics = @{
            @"labelPad": @(16.0f),
            @"messagePad": @(12.0f),
            @"labelT": @(8.0f),
            @"messageT":@(2.0f),
            @"messageB": @(8.0f),
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
            @"|-(messagePad)-[message]-(messagePad)-|"
                             options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"V:|-(labelT)-[label]-(messageT)-[message]-(messageB)-|"
                             options:0 metrics:metrics views:views]];
//    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight
//                            relatedBy:NSLayoutRelationEqual toItem:nil
//                           attribute:0 multiplier:0.0 constant:0.0]];

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
