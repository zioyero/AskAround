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

/**
* This view controller shows the logged in user profile with the ask that he can answer and the asks that he
* created.
* The VC has also a button to browse the user's list of friends
*/
@interface AAProfileViewController : UITableViewController <AAButtonCellDelegate>

@property (nonatomic, assign) BOOL configuredForCurrentUser;
@property (nonatomic, strong) AAMyProfileModelView *profileModelView;
@property (nonatomic, strong)UIViewController *friendsListViewController;

- (id)initWithPerson:(AAPerson *)person;
@end
