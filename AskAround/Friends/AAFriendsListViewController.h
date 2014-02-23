//
//  AAFriendsListViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//


@class AAFriendsListModelView;

/**
* View showing all of the friends in the user's network
*/
@interface AAFriendsListViewController : UITableViewController

@property (nonatomic, strong) AAFriendsListModelView *friendsModelView;

@end
