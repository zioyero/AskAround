//
//  AAProfilePhotoCell.m
//  AskAround
//
//  Created by Agathe Battestini on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAProfilePhotoCell.h"
#import "UIImageView+AFNetworking.h"
#import "AAPerson.h"

#define PHOTO_PADDING 80
#define PHOTO_OFFSET_CENTER_Y 24
#define PHOTO_HEIGHT 140

@implementation AAProfilePhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.autoresizesSubviews = YES;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.photoView = [[UIImageView alloc] init];
        self.photoView.translatesAutoresizingMaskIntoConstraints = NO;
        self.photoView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photoView];

        self.photoBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BgProfile"]];
        self.photoBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        self.photoBackgroundView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photoBackgroundView];

        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont lightFontWithSize:16.0];
        self.nameLabel.textColor = [UIColor darkerTextColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;

        NSMutableArray *constraints = [@[] mutableCopy];
        NSDictionary *views = @{
                @"image": self.photoView,
                @"label": self.nameLabel};
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
                @"[image(height)]"
                                                                                 options:0
                                                                                 metrics:@{@"height":@(PHOTO_HEIGHT)}
                                                                                   views:views]];
//        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[label]-8-|"
//                                                                                 options:0
//                                                                                 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-8-|"
                                                                                 options:0
                                                                                 metrics:nil views:views]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.photoView attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual toItem:self.photoView
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.photoView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.photoView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0 constant:-PHOTO_OFFSET_CENTER_Y]];

        [self.contentView addConstraints:constraints];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//
//    self.photoView.frame = CGRectMake(0.0, 0.0,
//            [AAProfilePhotoCell cellHeight]-PHOTO_PADDING,
//            [AAProfilePhotoCell cellHeight]-PHOTO_PADDING);
//    self.photoView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - PHOTO_OFFSET_CENTER_Y);
//    self.photoView.backgroundColor = [UIColor whiteColor];
//
//
    self.photoView.layer.cornerRadius = PHOTO_HEIGHT / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 200.0;
}

- (void)setObject:(id)object
{
    [super setObject:object];

    AAPerson *person = [self person];
    if(person){
        @weakify(self);
        [person fetchHttpPictureWithBlockWithBlock:^(NSURL *pictureURL, NSError *error) {
            [self.photoView setImageWithURL:pictureURL];
            [self updateName];
            [self setNeedsDisplay];
        }];
        [self updateName];
        [self setNeedsDisplay];
    }
}

- (AAPerson*)person
{
    if([self.object isKindOfClass:[AAPerson class]])
        return  (AAPerson *) self.object;
    return nil;
}

- (void) updateName
{
    AAPerson *person = [self person];
    if(person){
//        self.nameLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        self.nameLabel.text = person.name ?
                [NSString stringWithFormat:@"%@ (%@)\nAwesome Hacker at Launch", person.name, person.objectId]
                : [NSString stringWithFormat:@"%@ (%@)\n", person.facebookID, person.objectId];
        [self.nameLabel sizeToFit];
        [self setNeedsUpdateConstraints];
        [self setNeedsDisplay];
//        self.nameLabel.frame = CGRectMake(self.contentView.bounds.size.width / 2.0 - self.nameLabel.frame.size.width
//                / 2.0,
//                self.contentView.bounds.size.height - self.nameLabel.frame.size.height - 8.0,
//                self.nameLabel.frame.size.width,
//                self.nameLabel.frame.size.height);
//        self.nameLabel.center = CGPointMake(self.contentView.center.x,
//                self.contentView.bounds.size.height - self.nameLabel.frame.size.height / 2.0 -8.0);
    }
}

@end
