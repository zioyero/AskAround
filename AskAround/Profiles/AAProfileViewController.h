//
//  AAProfileViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class AAPerson;
@class AAMyProfileModelView;

@interface AAProfileViewController : UITableViewController


@property (nonatomic, strong) AAMyProfileModelView *profileModelView;

- (id)initWithPerson:(AAPerson *)person;
@end
