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
#import "AAButtonCell.h"

typedef NS_ENUM(NSInteger , MYPROFILE_SECTION){
  MYPROFILE_SECTION_PROFILE = 0,
  MYPROFILE_SECTION_FRIENDS_BUTTON=1,
  MYPROFILE_SECTION_PENDING=2,
  MYPROFILE_SECTION_MYASKS=3,
  MYPROFILE_SECTION_TEST_BUTTON=4

};
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
    if(person.objectId)
        self.person = person;
    else
        RAC(self, person) = [AAPerson fetchCurrentUser];



    return self;
}

#pragma mark - Prepping the data by creating sections and rows

- (void)prepareData
{
    if(self.person){
        // --- if changing the order of the section, you need to change the ENUM
        // profile things
        NSMutableArray *firstSection = [NSMutableArray array];
        [firstSection addObject:self.person];
        if(self.person.birthday)
            [firstSection addObject:self.person];

        // my friends
        NSArray * friendsRow = @[@"FriendsButton"];

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

        // test button
        NSArray * testRow = @[@"TestButton"];


        self.sections = @[firstSection, friendsRow, secondRow, thirdRow/*, testRow*/];
    }
}

#pragma mark - Data source for the tableview in the controller

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

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    switch (section){
        case MYPROFILE_SECTION_PENDING:
        case MYPROFILE_SECTION_MYASKS:
            return 44.0;
        default:
            return 0;
    }
}


- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case MYPROFILE_SECTION_PROFILE:
        {
            if(indexPath.row==0)
                return [AAProfilePhotoCell cellHeight];
            else
                return 44.0;
        }
        case MYPROFILE_SECTION_FRIENDS_BUTTON:
        case MYPROFILE_SECTION_TEST_BUTTON:
            return 156.0/2.0;

        case MYPROFILE_SECTION_PENDING:
        case MYPROFILE_SECTION_MYASKS:
        {
            RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
            if(object != [NSNull null])
                return 134 / 2.0;
            return 44.0;
        }
        default:
            return 44.0;
    }
}

- (RACTuple *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    RACTuple *tuple;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
/*    if(indexPath.section == MYPROFILE_SECTION_PENDING && indexPath.row < [self numberOfRowsInSection:indexPath
            .section]){
        return [RACTuple tupleWithObjects:[self.sections[indexPath.section] objectAtIndex:indexPath.row], nil];
    }
    else */if(indexPath.section == MYPROFILE_SECTION_MYASKS && indexPath.row < [self numberOfRowsInSection:indexPath
            .section]){
        NSNumber *answerMode = @(0);
        return [RACTuple tupleWithObjects:[self.sections[section] objectAtIndex:indexPath.row], answerMode, nil];
    }
    else if (indexPath.section < self.sections.count && indexPath.row < [self numberOfRowsInSection:indexPath
            .section]){
        return [RACTuple tupleWithObjects:[self.sections[indexPath.section] objectAtIndex:indexPath.row], nil];
    }
    return nil;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case MYPROFILE_SECTION_PROFILE:
        { // profile photo
            if(indexPath.row==0){
                return @"photoCell";
            }
            else if (indexPath.row==1){
                return @"birthdayCell";
            }
        }
        case MYPROFILE_SECTION_FRIENDS_BUTTON:
        case MYPROFILE_SECTION_TEST_BUTTON:
        {
            return @"buttonCell";
        }
        case MYPROFILE_SECTION_PENDING:
        { // ?
            RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
            if(object != [NSNull null])
                return @"askCell";
            return @"cell";
        }
        case MYPROFILE_SECTION_MYASKS:
        {
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
        case MYPROFILE_SECTION_PENDING:
        {
            return @"PENDING ASKS";
        }
        case MYPROFILE_SECTION_MYASKS:
        {
            return @"MY ASKS";
        }
        default:
            return nil;
    }
}

- (NSString*)emptyTextAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case MYPROFILE_SECTION_PENDING:
        {
            return @"No pending ask!";
        }
        case MYPROFILE_SECTION_MYASKS:
        {
            return @"You have not sent asks!";
        }
        default:
            return @"";
    }
}

#pragma mark - Cell identifiers for the VC

- (void)registerCellIdentifiersFor:(UITableView*)tableView
{
    [tableView registerClass:[AAProfilePhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [tableView registerClass:[AAButtonCell class] forCellReuseIdentifier:@"buttonCell"];
    [tableView registerClass:[AAProfileBirthdayCell class] forCellReuseIdentifier:@"birthdayCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[AAProfileAsk class] forCellReuseIdentifier:@"askCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"notificationsCell"];
}

#pragma mark Controlling whether things are clickable and what to show

- (BOOL)showFriendsListViewControllerForClickAt:(NSIndexPath *)indexPath
{
    if (indexPath.section==MYPROFILE_SECTION_FRIENDS_BUTTON && indexPath.row==0){
        RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
        if([object isKindOfClass:[NSString class]])
            return YES;
    }
    return NO;
}

- (BOOL)showAnswerForAskForClickAt:(NSIndexPath *)indexPath
{
    if(indexPath.section==MYPROFILE_SECTION_PENDING){
        return YES;
    }
    return NO;
}

#pragma mark - Row selection

- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==MYPROFILE_SECTION_PENDING){
        RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
        if([object isKindOfClass:[AAAsk class]])
            return indexPath;
    }
    else if (indexPath.section == MYPROFILE_SECTION_MYASKS){
        RACTupleUnpack(id object) = [self objectAtIndexPath:indexPath];
        if([object isKindOfClass:[AAAsk class]])
            return indexPath;
    }
    return nil;
}

- (BOOL)showCreateAskForClickAt:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Updating the data

- (void)refreshPerson
{
    @weakify(self);
    [self.person refreshWithCompletion:^(AAPerson *person, NSError *error) {
        @strongify(self);
        if(!error){
            self.person = person;
            NSLog(@"refreshed person %@, %d about, %d pending, %d sent", self.person, self.person.asksAbout.count,
            self.person.pendingAsks.count, self.person.sentAsks.count);

        }
        else{
            NSLog(@"error refresh");
        }
    }];
}

@end