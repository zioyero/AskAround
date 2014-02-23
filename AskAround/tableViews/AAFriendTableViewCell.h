//
//  AAFriendTableViewCell.h
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



#import "AAProfileCell.h"

@class AAPerson;

@interface AAFriendTableViewCell : AAProfileCell

//@property (nonatomic, strong) AAPerson * person;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel * nameLabel;
@end
