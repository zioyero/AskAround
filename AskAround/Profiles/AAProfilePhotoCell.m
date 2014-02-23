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

@implementation AAProfilePhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.autoresizesSubviews = YES;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];

        self.photoView = [[UIImageView alloc] init];
        self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.photoView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photoView];

        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont lightFontWithSize:16.0];
        self.nameLabel.textColor = [UIColor darkerTextColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.photoView.frame = CGRectMake(0.0, 0.0,
            [AAProfilePhotoCell cellHeight]-PHOTO_PADDING,
            [AAProfilePhotoCell cellHeight]-PHOTO_PADDING);
    self.photoView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - PHOTO_OFFSET_CENTER_Y);
    self.photoView.backgroundColor = [UIColor whiteColor];

    self.photoView.layer.cornerRadius = ([AAProfilePhotoCell cellHeight] - PHOTO_PADDING) / 2.0;

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
        self.nameLabel.text = person.name ?
                [NSString stringWithFormat:@"%@ (%@)\nAwesome Hacker at Launch", person.name, person.objectId]
                : [NSString stringWithFormat:@"%@ (%@)\n", person.facebookID, person.objectId];
        self.nameLabel.frame = self.contentView.bounds;
        [self.nameLabel sizeToFit];
        self.nameLabel.center = CGPointMake(self.contentView.center.x,
                self.contentView.bounds.size.height - self.nameLabel.frame.size.height / 2.0 -8.0);
    }
}

@end
