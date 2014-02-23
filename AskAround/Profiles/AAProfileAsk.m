//
//  AAProfileAsk.m
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAProfileAsk.h"
#import "AAAsk.h"

@implementation AAProfileAsk

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }

    // Initialization code
    self.pictureView = [[UIImageView alloc] init];
    self.pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.pictureView];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureView.backgroundColor = [UIColor lightGrayColor];

    self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.font = [UIFont mediumFontWithSize:14.0];
    self.nameLabel.textColor = [UIColor darkerTextColor];

    [self.contentView addSubview:self.nameLabel];


    NSMutableArray *constraints = [@[] mutableCopy];
    NSDictionary *views = @{
            @"image": self.pictureView,
            @"label": self.nameLabel};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"|-16-[image]-12-[label]-16-|"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.5-[image]-5.5-|"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.pictureView attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual toItem:self.pictureView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0 constant:0.0]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.5-[label]"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [self.contentView addConstraints:constraints];


    return self;
}

- (void)setObject:(id)object
{
    [super setObject:object];

    AAAsk *ask = [self ask];
    if(ask && ask != [NSNull null]){
        if(ask.isDataAvailable)
            self.nameLabel.text = [NSString stringWithFormat:@"%@", ask.title ];
        else
            self.nameLabel.text = [NSString stringWithFormat:@"Loading %@", ask.objectId ];

    }
}

- (AAAsk*)ask
{
    if(self.object && self.object != [NSNull null] && [self.object isKindOfClass:[AAAsk class]])
        return  (AAAsk *) self.object;
    return nil;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.pictureView setImage:nil];
    self.nameLabel.text = @"";
}

@end
