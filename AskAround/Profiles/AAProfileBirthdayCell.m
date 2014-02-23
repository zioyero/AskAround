//
//  AAProfileBirthdayCell.m
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAProfileBirthdayCell.h"
#import "AAPerson.h"

@implementation AAProfileBirthdayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont lightFontWithSize:14.0];
        self.textLabel.textColor = [UIColor lighterTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setObject:(id)object
{
    [super setObject:object];

    AAPerson *person = [self person];
    if(person){
        self.textLabel.text = [NSString stringWithFormat:@"%@ | %@", [self birthday], [self location] ];
    }
}

- (AAPerson*)person
{
    if([self.object isKindOfClass:[AAPerson class]])
        return  (AAPerson *) self.object;
    return nil;
}

- (NSString*)birthday
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd"];
    if(self.person.birthday)
        return [dateFormat stringFromDate:self.person.birthday];
    return @"";
}

- (NSString*)location
{
    if(self.person)
        return @"San Francisco, CA";
    return nil;
}


@end
