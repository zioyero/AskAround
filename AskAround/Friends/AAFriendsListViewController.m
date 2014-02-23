//
//  AAFriendsListViewController.m
//  AskAround
//
//  Created by Agathe Battestini on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAFriendsListViewController.h"
#import "AAFriendsListModelView.h"
#import "AAFriendTableViewCell.h"
#import "AAAsk.h"
#import "AAPerson.h"
#import "AAProfileViewController.h"

@interface AAFriendsListViewController ()

@end

@implementation AAFriendsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (!self) return nil;
    self.title = @"My Friends";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[AAFriendTableViewCell class] forCellReuseIdentifier:@"friendCell"];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;

    self.friendsModelView = [[AAFriendsListModelView alloc] init];

    @weakify(self);
    [RACObserve(self.friendsModelView, friends) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];

}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableSet * letters = [NSMutableSet set];
    
    for( int i = 0; i< self.friendsModelView.friends.count; i++ ){
        AAPerson * p = [self.friendsModelView.friends objectAtIndex:i];
        NSString * abbrev = [p.name substringWithRange:NSMakeRange(0, 1)];
        [letters addObject:abbrev];
    }
    return [letters sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES] ]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    for( int i = 0; i< self.friendsModelView.friends.count; i++ ){
        AAPerson * p = [self.friendsModelView.friends objectAtIndex:i];
        NSString * abbrev = [p.name substringWithRange:NSMakeRange(0, 1)];
        if( [abbrev isEqualToString:title] )
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            return i;
            break;
        }
    }
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.friendsModelView.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    AAFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setObject:[self.friendsModelView.friends objectAtIndex:indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 162.0 / 2.0;
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAPerson * person = [self.friendsModelView.friends objectAtIndex:indexPath.row];
//    AAAsk * ask = [[AAAsk alloc] initWithTitle:@"New ask! For Debugging!" andBody:@"No body"];
//    [AAAsk sendOutAsk:ask aboutPerson:person];

    AAProfileViewController * viewController = [[AAProfileViewController alloc] initWithPerson:person];
    [self.navigationController pushViewController:viewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
