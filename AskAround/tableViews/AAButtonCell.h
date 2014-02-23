//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAProfileCell.h"

@class AAButtonCell;

@protocol AAButtonCellDelegate

- (void)buttonCell:(AAButtonCell*)cell clicked:(BOOL)flag;
@end

@interface AAButtonCell : AAProfileCell

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) id<AAButtonCellDelegate> buttonClickDelegate;

@end