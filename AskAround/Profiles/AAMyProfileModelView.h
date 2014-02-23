//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/RVMViewModel.h>

@class AAPerson;


@interface AAMyProfileModelView : RVMViewModel

@property (nonatomic, strong) AAPerson* person;

@property (nonatomic, strong) NSArray *sections;



- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSUInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)headerTitleForSection:(NSInteger)section;

- (void)registerCellIdentifiersFor:(UITableView *)tableView;
@end