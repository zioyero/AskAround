//
// Created by Agathe Battestini on 2/22/14.
// Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAMyProfileModelView.h"
#import "AAPerson.h"
#import "AAProfilePhotoCell.h"


@interface  AAMyProfileModelView()


@end


@implementation AAMyProfileModelView {

}

-(instancetype)init {
    self = [super init];
    if (!self) return nil;

    RAC(self, person) = [AAPerson fetchCurrentUser];
    self.sections = [NSArray array];


    @weakify(self);
    [RACObserve(self, person) subscribeNext:^(id x) {
        @strongify(self);
        [self prepareData];
    }];

    return self;
}

- (void)prepareData
{
    if(self.person){
        NSArray *firstRow = @[self.person, self.person];
        NSArray *secondRow = @[[NSNull null]];
        self.sections = @[firstRow, secondRow];
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

- (void)registerCellIdentifiersFor:(UITableView*)tableView
{
    [tableView registerClass:[AAProfilePhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"birthdayCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"requestCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"notificationsCell"];

}

@end