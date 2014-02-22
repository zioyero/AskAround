//
//  AAProfilePhotoCell.h
//  AskAround
//
//  Created by Agathe Battestini on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@interface AAProfilePhotoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;


+ (CGFloat)cellHeight;
@end
