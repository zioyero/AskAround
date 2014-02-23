//
// Created by Agathe Battestini on 2/23/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AAAskingPersonMessageView.h"
#import "AAPerson.h"
#import "AAAsk.h"


@implementation AAAskingPersonMessageView {

}

- (id)initWithAsk:(AAAsk*)ask andFromPerson:(AAPerson*)person
{
    self = [super init];
    if (!self) { return nil; }

    self.intrinsicHeight = 44.0;

    // Initialization code
    self.pictureView = [[UIImageView alloc] init];
    self.pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.pictureView];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureView.backgroundColor = [UIColor lightGrayColor];
    [self.pictureView setImage:[UIImage imageNamed:@"DefaultProfile"]];

    self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.textColor = [UIColor darkerTextColor];
    self.nameLabel.font = [UIFont mediumFontWithSize:14.0];
//    self.nameLabel.backgroundColor = [UIColor blueColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];


    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *views = @{
            @"image": self.pictureView,
            @"label": self.nameLabel};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: // 44 -4 -4
            @"|-16-[image(36)]-12-[label]-16-|"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[image]"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[label]"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.pictureView attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual toItem:self.pictureView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0 constant:0.0]];

    [self addConstraints:constraints];

    [self setAsk:ask andFromPerson:person];

    return self;
}


- (void)setAsk:(AAAsk *)ask andFromPerson:(AAPerson*)person
{
    _ask = ask;
    _fromPerson = person;
    [self updateLabel];
}

- (void)setFromPerson:(AAPerson *)fromPerson {
    _fromPerson = fromPerson;
    [self updateLabel];
}

- (void)setAsk:(AAAsk *)ask {
    _ask = ask;
    [self updateLabel];
}


- (void)updateLabel
{
    NSString *title = [NSString stringWithFormat:@"%@", self.fromPerson.name ? self.fromPerson.name :
            @""];
    NSString *body = [NSString stringWithFormat:@"%@", self.ask.body ? self.ask.body : @"(loading)"];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[[NSAttributedString alloc]
            initWithString:title
                attributes:[UIFont mediumStringAttributesWithSize:14.0
                                                        withColor:[UIColor darkerTextColor]]] ];
    [string appendAttributedString:[[NSAttributedString alloc]
            initWithString:@" is asking: \n"
                attributes:[UIFont mediumStringAttributesWithSize:12.0
                                                        withColor:[UIColor lighterTextColor]]] ];
    [string appendAttributedString:[[NSAttributedString alloc]
            initWithString:self.ask.body ? self.ask.body : @""
                attributes:[UIFont lightStringAttributesWithSize:12.0
                                                       withColor:[UIColor lighterTextColor]]] ];

    self.nameLabel.attributedText = string;
    [self.fromPerson fetchHttpPictureWithBlockWithBlock:^(NSURL *pictureURL, NSError *error) {
        [self.pictureView setImageWithURL:pictureURL];
    }];
    [self.nameLabel sizeToFit];
    self.intrinsicHeight = MAX(self.nameLabel.bounds.size.height + 4 * 2, 44);
    [self setNeedsUpdateConstraints];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.intrinsicHeight);
}


@end