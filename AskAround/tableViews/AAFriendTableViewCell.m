//
//  AAFriendTableViewCell.m
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAFriendTableViewCell.h"
#import "AAPerson.h"
#import "UIImageView+AFNetworking.h"

@implementation AAFriendTableViewCell

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
//    self.nameLabel.backgroundColor = [UIColor blueColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];


    NSMutableArray *constraints = [@[] mutableCopy];
    NSDictionary *views = @{
            @"image": self.pictureView,
            @"label": self.nameLabel};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:
            @"|-16-[image(70)]-12-[label]-16-|"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.5-[image(70)]"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.5-[label]"
                                                                             options:0
                                                                             metrics:nil views:views]];
    [self.contentView addConstraints:constraints];


    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPerson:(AAPerson *)person {
    _person = person;
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@", [self name], [self birthday]];
    [person fetchPictureWithBlock:^(NSString *url, NSError *error) {
        if(!error){
            NSInteger colon = [url rangeOfString:@":"].location;
            if (colon != NSNotFound) { // wtf how would it be missing
                url = [url substringFromIndex:colon]; // strip off existing scheme
                url = [@"http" stringByAppendingString:url];
            }
            [self.pictureView setImageWithURL:[NSURL URLWithString:url]];
        }

    }];
}

- (NSString *)name
{
    return self.person.name ? self.person.name : @"(loading)";
}

- (NSString*)birthday
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd"];
    if(self.person.birthday)
        return [dateFormat stringFromDate:self.person.birthday];
    return @"";
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.pictureView setImage:nil];
    self.nameLabel.text = @"";
}


@end
