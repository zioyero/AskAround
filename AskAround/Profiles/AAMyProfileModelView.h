//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/RVMViewModel.h>

@class AAPerson;


/**
* A MyProfileModelView encapsulates and provide the structured data that we should about the logged in user
* It provides lots of methods that are typically called to fill in a UITableView
*/
@interface AAMyProfileModelView : RVMViewModel

/**
* The person (here it would be the logged in person)
*/
@property (nonatomic, strong) AAPerson* person;

/**
* The structured data for the TableView, sections (table sections) contains arrays of objects (rows)
*/
@property (nonatomic, strong) NSArray *sections;



- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSUInteger)section;

- (CGFloat)heightForHeaderInSection:(NSInteger)section;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (RACTuple *)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)headerTitleForSection:(NSInteger)section;

- (NSString *)emptyTextAtIndexPath:(NSIndexPath *)indexPath;

- (void)registerCellIdentifiersFor:(UITableView *)tableView;

- (BOOL)showFriendsListViewControllerForClickAt:(NSIndexPath *)indexPath;

- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)showCreateAskForClickAt:(NSIndexPath *)indexPath;

- (void)refreshPerson;
@end