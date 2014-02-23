//
//  AAProfileViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



#import "AAButtonCell.h"

@class AAPerson;
@class AAMyProfileModelView;

@interface AAProfileViewController : UITableViewController <AAButtonCellDelegate>

@property (nonatomic, assign) BOOL currentUserView;
@property (nonatomic, strong) AAMyProfileModelView *profileModelView;
@property (nonatomic, strong)UIViewController *friendsListViewController;

- (id)initWithPerson:(AAPerson *)person;
@end
