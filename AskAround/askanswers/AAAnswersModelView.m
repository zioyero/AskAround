//
// Created by Agathe Battestini on 2/23/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAnswersModelView.h"
#import "AAAsk.h"
#import "AAPerson.h"
#import "AAProfileAsk.h"


@implementation AAAnswersModelView {

}

-(instancetype)initWithAsk:(AAAsk *)ask{
    self = [super init];
    if (!self) return nil;

    self.sections = [NSArray array];

    @weakify(self);
    [RACObserve(self, ask) subscribeNext:^(id x) {
        @strongify(self);
        [self prepareData];
    }];


    self.ask = ask;
//    AAPerson *person = [AAPerson currentUser];
//    if(person)
//        self.person = person;
//    else
//            RAC(self, person) = [AAPerson fetchCurrentUser];


    return self;
}

- (void)prepareData
{
    if(self.ask){
//        NSArray *fIds = @[self.ask.aboutPersonID, self.ask.fromPersonID];
//        @weakify(self);
//        [AAPerson findPeopleWithFacebookIDs:fIds withBlock:^(NSArray *people, NSError *error) {
//            @strongify(self);

            // about, from
//            NSArray *firstSection = people;

            NSArray *secondSection = self.ask.answers;
            if(secondSection)
                self.sections = @[secondSection];
//        }];
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

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    switch (section){
        default:
            return 0.0;
    }
}


- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 0:
        {
            return 156.0/2.0;
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
        default:
        {
            return @"askCell";
        }
    }
    return @"cell";
}

- (NSString *)headerTitleForSection:(NSInteger)section
{
    switch (section){
        default:
            return nil;
    }
}

- (NSString*)emptyTextAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        default:
            return nil;
    }
}

- (void)registerCellIdentifiersFor:(UITableView*)tableView
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[AAProfileAsk class] forCellReuseIdentifier:@"askCell"];
    [tableView registerClass:[AAProfileAsk class] forCellReuseIdentifier:@"answerCell"];
}

@end