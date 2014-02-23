//
//  AAAskMessageView.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class GCPlaceholderTextView;

@interface AAAskMessageView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) GCPlaceholderTextView *textView;

@property (nonatomic, assign) NSNumber * hasValidBody;

- (NSString *)messageBody;
@end
