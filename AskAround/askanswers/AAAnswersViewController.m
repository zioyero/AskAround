//
//  AAAnswersViewController.m
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAnswersViewController.h"
#import "AAAsk.h"
#import "AAAnswersModelView.h"

@interface AAAnswersViewController ()

@end

@implementation AAAnswersViewController

- (id)initWithAsk:(AAAsk*)ask
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

    self.answerModelView = [[AAAnswersModelView alloc] initWithAsk:ask];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.answerModelView registerCellIdentifiersFor:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];

    @weakify(self);
    [RACObserve(self.answerModelView, sections) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.answerModelView numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.answerModelView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resultCell;

    NSString *cellIdentifier = [self.answerModelView cellIdentifierAtIndexPath:indexPath];
    resultCell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    id object = [self.answerModelView objectAtIndexPath:indexPath];
    if(object && [resultCell respondsToSelector:@selector(setObject:)])
        [resultCell performSelector:@selector(setObject:) withObject:object];
    else{
        NSString *text = @"??"; //[self.answerModelView emptyTextAtIndexPath:indexPath];

        NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:
                [UIFont lightItalicStringAttributesWithSize:12.0 withColor:[UIColor lighterTextColor]]];
        resultCell.textLabel.attributedText = string;
    }

//    if([resultCell respondsToSelector:@selector(setButtonClickDelegate:)]){
//        [resultCell performSelector:@selector(setButtonClickDelegate:) withObject:self];
//    }


    return resultCell;
}


@end
