//
// Created by Agathe Battestini on 2/23/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/RVMViewModel.h>

@class AAAsk;


@interface AAAnswersModelView : RVMViewModel

@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, strong) NSArray *answers;

@property (nonatomic, strong) AAAsk *ask;


- (instancetype)initWithAsk:(AAAsk *)ask;

- (instancetype)initWithAsk:(AAAsk *)ask withAnswers:(NSArray *)answers;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSUInteger)section;

- (CGFloat)heightForHeaderInSection:(NSInteger)section;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)headerTitleForSection:(NSInteger)section;

//- (NSString *)emptyTextAtIndexPath:(NSIndexPath *)indexPath;

- (void)registerCellIdentifiersFor:(UITableView *)tableView;

//- (BOOL)showFriendsListViewControllerForClickAt:(NSIndexPath *)indexPath;

//- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//- (BOOL)showCreateAskForClickAt:(NSIndexPath *)indexPath;

//- (void)refreshPerson;


@end