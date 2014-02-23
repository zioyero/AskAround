//
//  AAAskPersonHeaderView.m
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAskPersonHeaderView.h"
#import "AAPerson.h"
#import "UIImageView+AFNetworking.h"

@implementation AAAskPersonHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) { return nil; }

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
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"|-16-[image]-12-[label]-16-|"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[image]-4-|"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.pictureView attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual toItem:self.pictureView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0 constant:0.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0 constant:0.0]];

    [self addConstraints:constraints];


    return self;
}


- (void)setPerson:(AAPerson *)person {
    _person = person;
    [self updateLabel];
}

- (void)updateLabel
{
    self.nameLabel.text = [NSString stringWithFormat:@"Gift idea for %@", self.person.name];
    [self.person fetchHttpPictureWithBlockWithBlock:^(NSURL *pictureURL, NSError *error) {
        [self.pictureView setImageWithURL:pictureURL];
    }];
    [self.nameLabel sizeToFit];
    [self setNeedsUpdateConstraints];
}

@end
