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
#import "NSLayoutConstraint+SimpleFormatLanguage.h"

@interface AAFriendTableViewCell ()

@property (nonatomic, strong) UILabel * infoLabel;

@property (nonatomic, strong) UIView * pictureFrame;

@end

@implementation AAFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }

    // Initialization code



    // Picture Frame (1 pixel of gray around the picture)
    self.pictureFrame = [[UIView alloc] init];
    self.pictureFrame.translatesAutoresizingMaskIntoConstraints = NO;
    self.pictureFrame.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.pictureFrame];

    // Picture
    self.pictureView = [[UIImageView alloc] init];
    self.pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.pictureView];

    // Name label
    self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.nameLabel.backgroundColor = [UIColor blueColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont mediumFontWithSize:16.0f];
    self.nameLabel.textColor = [UIColor darkerTextColor];
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];

    // Location and birthday
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.font = [UIFont lightFontWithSize:14.0f];
    self.infoLabel.textColor = [UIColor lighterTextColor];
    self.infoLabel.numberOfLines = 0;
    [self.contentView addSubview:self.infoLabel];


    #if 0
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
    #endif

    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    UIView * picture = self.pictureView;
    UIView * name = self.nameLabel;
    UIView * info = self.infoLabel;
    UIView * superview = self.contentView;
    UIView * frame = self.pictureFrame;

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithSimpleFormat:@[@"picture.left = superview.left + 16",
                                                                                       @"picture.width = 70",
                                                                                       @"picture.top  = superview.top + 5.5",
                                                                                       @"picture.height = 70",
                                                                                       @"frame.left = picture.left - 1",
                                                                                       @"frame.right = picture.right + 1",
                                                                                       @"frame.top = picture.top - 1",
                                                                                       @"frame.bottom = picture.bottom + 1",
                                                                                       @"frame.centerX = picture.centerX",
                                                                                       @"frame.centerY = picture.centerY",
                                                                                       @"name.left = picture.right + 16",
                                                                                       @"name.right <= superview.right - 16",
                                                                                       @"name.top = superview.top + 5.5"
                                                                                       @"info.right <= name.right",
                                                                                       @"info.left = name.left",
                                                                                       @"info.top = name.bottom + 3"]
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(picture, name, info, superview, frame)]];

    [self.contentView addConstraints:constraints];

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setObject:(id)object
{
    [super setObject:object];

    AAPerson *person = [self person];
    if(person){
        @weakify(self);
        self.nameLabel.text = [NSString stringWithFormat:@"%@", [self name]];
        self.infoLabel.text = [self infoText];
        if(person.picture)
        {
            [self.pictureView setImageWithURL:[NSURL URLWithString:person.picture]];
        }
        else
        {
            [person fetchHttpPictureWithBlockWithBlock:^(NSURL *pictureURL, NSError *error) {
                [self.pictureView setImageWithURL:pictureURL placeholderImage:[UIImage imageNamed:@"DefaultProfile"]];
            }];
        }
        [self setNeedsDisplay];
    }
}


- (NSString *)name
{
    return self.person.name ? self.person.name : @"(loading)";
}

- (NSString*)birthday
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d"];
    if(self.person.birthday)
        return [dateFormat stringFromDate:self.person.birthday];
    return @"";
}

- (NSString *)location
{
    return self.person.location ? self.person.location : @"";
}

- (NSString *)infoText
{
    if(self.person.location && self.person.birthday)
    {
        return [NSString stringWithFormat:@"%@\n%@", self.person.location, [self birthday]];
    }
    else if(self.person.birthday)
    {
        return [self birthday];
    }
    else if(self.person.location)
    {
        return self.person.location;
    }
    return @"";
}

- (void)prepareForReuse
{
    [super prepareForReuse];
//    [self.pictureView setImage:nil];
    [self.pictureView setImage:[UIImage imageNamed:@"DefaultProfile"]];
    self.nameLabel.text = @"";
}

- (AAPerson*)person
{
    if([self.object isKindOfClass:[AAPerson class]])
        return  (AAPerson *) self.object;
    return nil;
}


@end
