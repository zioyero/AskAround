//
//  AAProfileCell.m
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAProfileCell.h"

@implementation AAProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lineView = [[UIView alloc] initWithFrame:self.bounds];
        self.lineView.backgroundColor = [UIColor backgroundGrayColor];
        [self.contentView addSubview:self.lineView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height - 2.0;
    frame.size.height = 2.0;
    self.lineView.frame = frame;
    [self bringSubviewToFront:self.lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setObject:(id)object {
    _object = object;
}


@end

