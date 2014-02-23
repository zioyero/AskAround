//
//  AAAskPersonHeaderView.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//


@class AAPerson;


@interface AAAskPersonHeaderView : UIView

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) AAPerson *person;

@end
