//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAMyProfileModelView.h"
#import "AAPerson.h"
#import "AAProfilePhotoCell.h"
#import "AAProfileBirthdayCell.h"


@interface  AAMyProfileModelView()


@end


@implementation AAMyProfileModelView {

}

-(instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.sections = [NSArray array];
    @weakify(self);
    [RACObserve(self, person) subscribeNext:^(id x) {
        @strongify(self);
        [self prepareData];
    }];

    AAPerson *person = [AAPerson currentUser];
    if(person)
        self.person = person;
    else
        RAC(self, person) = [AAPerson fetchCurrentUser];



    return self;
}

- (void)prepareData
{
    if(self.person){
        // profile things
        NSMutableArray *firstSection = [NSMutableArray array];
        [firstSection addObject:self.person];
        if(self.person.birthday)
            [firstSection addObject:self.person];

        // pending requests
        NSArray *secondRow = @[[NSNull null]];


        self.sections = @[firstSection, secondRow];
    }
}

- (NSInteger)numberOfSections {
    // 0: profile image
    // pending asks
    // my asks
    return self.sections.count;
}

- (NSInteger)numberOfRowsInSection:(NSUInteger)section
{
    if(section < self.sections.count)
        return [(NSArray*)self.sections[section] count];
    return 0;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.sections.count && indexPath.row < [self numberOfRowsInSection:indexPath.section])
        return [self.sections[indexPath.section] objectAtIndex:indexPath.row];
    return nil;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 0:
        { // profile photo
            if(indexPath.row==0){
                return @"photoCell";
            }
            else if (indexPath.row==1){
                return @"birthdayCell";
            }
        }
        case 1:
        { // ?
            return @"requestCell";
        }
    }
    return @"cell";
}

- (NSString *)headerTitleForSection:(NSInteger)section
{
    switch (section){
        case 0:
        { // profile photo
            return nil;
        }
        case 1:
        { // ?
            return @"Pending Requests";
        }
    }
    return nil;
}


- (void)registerCellIdentifiersFor:(UITableView*)tableView
{
    [tableView registerClass:[AAProfilePhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [tableView registerClass:[AAProfileBirthdayCell class] forCellReuseIdentifier:@"birthdayCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"requestCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"notificationsCell"];
}


@end