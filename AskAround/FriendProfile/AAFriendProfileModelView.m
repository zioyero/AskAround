//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAFriendProfileModelView.h"
#import "AAPerson.h"
#import "AAProfileAsk.h"
#import "AAProfileBirthdayCell.h"
#import "AAProfilePhotoCell.h"
#import "AAButtonCell.h"


@implementation AAFriendProfileModelView {

}
-(instancetype)initWithPerson:(AAPerson*)person {
    self = [super init];
    if (!self) return nil;

    self.sections = [NSArray array];
    @weakify(self);
    [RACObserve(self, person) subscribeNext:^(id x) {
        @strongify(self);
        [self prepareData];
    }];

    self.person = person;
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

        // ask about
        NSArray * askRow = @[@"AskButton"];

        // about asks (asks about this person)
        NSArray *secondRow = self.person.asksAbout;
        if(!secondRow){
            secondRow = @[[NSNull null]];
        }

        self.sections = @[firstSection, askRow, secondRow];
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
        case 2:
        {
            RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
            if(object != [NSNull null])
                return 134 / 2.0;
            return 44.0;
        }
        case 1:
            return 156.0/2.0;

        default:
            return 44.0; // big cell, 134/2, 84/2
    }
}

- (RACTuple *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.sections.count && indexPath.row < [self numberOfRowsInSection:indexPath.section])
        return [RACTuple tupleWithObjects:[self.sections[indexPath.section] objectAtIndex:indexPath.row], nil];
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
        {
            return @"buttonCell";
        }
        case 2:
        { // ?
            RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
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
        case 2:
        { // ?
            return @"FRIENDS HAVE ASKED";
        }
        default:
            return nil;
    }
}

- (NSString*)emptyTextAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 2:
        { // ?
            return @"No ask about this friend";
        }
        default:
            return nil;
    }
}

- (void)registerCellIdentifiersFor:(UITableView*)tableView
{
    [tableView registerClass:[AAProfilePhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [tableView registerClass:[AAProfileBirthdayCell class] forCellReuseIdentifier:@"birthdayCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[AAProfileAsk class] forCellReuseIdentifier:@"askCell"];
    [tableView registerClass:[AAButtonCell class] forCellReuseIdentifier:@"buttonCell"];
}

- (BOOL)showFriendsListViewControllerForClickAt:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)showCreateAskForClickAt:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row==0)
        return YES;
    return NO;
}


@end