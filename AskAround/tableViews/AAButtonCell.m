//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAButtonCell.h"


@implementation AAButtonCell {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont lightFontWithSize:14.0];
        self.textLabel.textColor = [UIColor lighterTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor backgroundGrayColor];

        self.button = [[UIButton alloc] initWithFrame:self.contentView.frame];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        NSMutableArray *constraints = [@[] mutableCopy];
        NSDictionary *views = @{
                @"image": self.button,
        };
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.button
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.button
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0 constant:0.0]];
        [self.contentView addConstraints:constraints];



    }
    return self;
}

- (void)setObject:(id)object
{
    [super setObject:object];

    NSString *buttonName = [self buttonName];
    if(buttonName){
        [self.button setImage:[UIImage imageNamed:buttonName] forState:UIControlStateNormal];
        self.textLabel.text = buttonName;
    }
}

- (NSString*)buttonName
{
    if([self.object isKindOfClass:[NSString class]])
        return  (NSString *) self.object;
    return nil;
}

- (void)setButtonClickDelegate:(id)buttonClickDelegate {
    _buttonClickDelegate = buttonClickDelegate;

}

- (void)buttonClicked:(id<AAButtonCellDelegate>)sender{

    if(self.buttonClickDelegate){
        [self.buttonClickDelegate buttonCell:self clicked:YES];
    }
}



@end