//
//  AAProfileViewController.m
//  AskAround
//
//  Created by Agathe Battestini on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAProfileViewController.h"
#import "AAPerson.h"
#import "AAProfilePhotoCell.h"
#import "AAMyProfileModelView.h"
#import "AAFriendProfileModelView.h"
#import "AAFriendsListViewController.h"

@interface AAProfileViewController ()

@end



@implementation AAProfileViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];

    if (! self) { return nil ; }

    self.profileModelView = [[AAMyProfileModelView alloc] init];
    self.currentUserView = YES;

    return self;

}

- (id)initWithPerson:(AAPerson*)person
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (! self) { return nil ; }

    self.profileModelView = [[AAFriendProfileModelView alloc] initWithPerson:person];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.currentUserView){
        self.title = @"ME";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ME"
                                                        image:[UIImage imageNamed:@"TabHome"]
                                                selectedImage:[UIImage imageNamed:@"TabHomeSelected"]];
    }
    [self.profileModelView registerCellIdentifiersFor:self.tableView];
//    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    @weakify(self);
    [RACObserve(self.profileModelView, sections) subscribeNext:^(id x) {
        @strongify(self);
        [self reloadProfile];
    }];

    [[self rac_signalForSelector:@selector(buttonCell:clicked:)
                    fromProtocol:@protocol(AAButtonCellDelegate)] subscribeNext:^(RACTuple *value) {
        @strongify(self);
        UITableViewCell *cell = [value objectAtIndex:0];
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        NSLog(@"button clicked %@", path);
        if([self.profileModelView showFriendsListViewControllerForClickAt:path]){
            AAFriendsListViewController *viewController = [[AAFriendsListViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if([self.profileModelView showCreateAskForClickAt:path]){

        }
        else{
            // TEST BUTTON????
        }
    }];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.currentUserView){
        AAPerson *person = [AAPerson currentUser];
        if(person)
            self.profileModelView.person = person;

    }
}

- (void)reloadProfile
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.profileModelView.person.name];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.profileModelView numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.profileModelView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resultCell;

    NSString *cellIdentifier = [self.profileModelView cellIdentifierAtIndexPath:indexPath];
    resultCell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    id object = [self.profileModelView objectAtIndexPath:indexPath];
    if(object && [resultCell respondsToSelector:@selector(setObject:)])
        [resultCell performSelector:@selector(setObject:) withObject:object];
    else{
        NSString *text = [self.profileModelView emptyTextAtIndexPath:indexPath];
        resultCell.textLabel.text = text;
    }

    if([resultCell respondsToSelector:@selector(setButtonClickDelegate:)]){
        [resultCell performSelector:@selector(setButtonClickDelegate:) withObject:self];
    }


    return resultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.profileModelView heightForRowAtIndexPath:indexPath];
//    if(indexPath.section==0 && indexPath.row==0){
//        return [AAProfilePhotoCell cellHeight];
//    }
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.profileModelView heightForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.profileModelView headerTitleForSection:section];
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
