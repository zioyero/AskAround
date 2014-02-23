//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAMyProfileModelView.h"
#import "AAPerson.h"
#import "AAProfilePhotoCell.h"
#import "AAProfileBirthdayCell.h"
#import "AAAsk.h"
#import "AAProfileAsk.h"


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
        NSArray *secondRow = self.person.pendingAsks;
        if(!secondRow){
//            @weakify(self);
//            [AAPerson findPeopleWithFacebookIDs:@[@"585384921", @"718387594"
//            ] withBlock:^(NSArray *people, NSError *error) {
//                AAAsk *newAsk = [[AAAsk alloc] initWithFromPerson:people[1] aboutPerson:people[0]
//                                                        withTitle:@"What should i do for her?"];
//                [AAAsk sendOutAsk:newAsk aboutPerson:people[0]];
//
//            }];

            secondRow = @[[NSNull null]];
        }

        // sent asks
        NSArray *thirdRow = self.person.sentAsks;
        if(!thirdRow)
            thirdRow = @[[NSNull null]];

        self.sections = @[firstSection, secondRow, thirdRow];
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

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 0:
        {
            if(indexPath.row==0)
                return [AAProfilePhotoCell cellHeight];
            else
                return 44.0;
        }
        case 1:
        case 2:
        {
            id object = [self objectAtIndexPath:indexPath];
            if(object != [NSNull null])
                return 134 / 2.0;
            return 44.0;
        }
        default:
            return 44.0; // big cell, 134/2, 84/2
    }
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
            id object = [self objectAtIndexPath:indexPath];
            if(object != [NSNull null])
                return @"askCell";
            return @"cell";
        }
        case 2:
        {
            id object = [self objectAtIndexPath:indexPath];
            if(object != [NSNull null])
                return @"askCell";
            return @"cell";
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
            return @"PENDING ASKS";
        }
        case 2:
        { // ?
            return @"MY ASKS";
        }
    }
    return nil;
}

- (NSString*)emptyTextAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 0:
        { // profile photo
            return @"";
        }
        case 1:
        { // ?
            return @"No pending ask!";
        }
        case 2:
        { // ?
            return @"You have not sent asks!";
        }
    }
    return nil;
}

- (void)registerCellIdentifiersFor:(UITableView*)tableView
{
    [tableView registerClass:[AAProfilePhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [tableView registerClass:[AAProfileBirthdayCell class] forCellReuseIdentifier:@"birthdayCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[AAProfileAsk class] forCellReuseIdentifier:@"askCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"notificationsCell"];
}


@end