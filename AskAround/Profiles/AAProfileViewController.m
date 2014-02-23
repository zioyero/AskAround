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

@interface AAProfileViewController ()

@end



@implementation AAProfileViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];

    if (! self) { return nil ; }

    self.profileModelView = [[AAMyProfileModelView alloc] init];

    return self;

}

- (id)initWithPerson:(AAPerson*)person
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (! self) { return nil ; }

    self.profileModelView = [[AAMyProfileModelView alloc] init];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"";
    [self.profileModelView registerCellIdentifiersFor:self.tableView];
//    [self.tableView registerClass:[AAProfilePhotoCell class] forCellReuseIdentifier:@"photoCell"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"birthdayCell"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"requestCell"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"notificationsCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ME" image:nil
                                            selectedImage:nil];

    @weakify(self);
    [RACObserve(self.profileModelView, sections) subscribeNext:^(id x) {
        @strongify(self);
        [self reloadProfile];
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    #if 0
    [AAPerson friendsWithBlock:^(NSArray * friends, NSError * error)
    {
        NSLog(@"%@", friends);
    }];
    #endif
}

- (void)reloadProfile
{
    self.title = [NSString stringWithFormat:@"Name: %@",self.profileModelView.person.name];
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
    if([resultCell respondsToSelector:@selector(setObject:)])
        [resultCell performSelector:@selector(setObject:) withObject:object];
    else
        resultCell.textLabel.text = @"something";

//    switch (indexPath.section){
//        case 0:
//        { // profile photo
//            if(indexPath.row==0){
//                // photo cell
//                AAProfilePhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
//                id object = [self.profileModelView objectAtIndexPath:indexPath];
//                resultCell = cell;
//            }
//            else if (indexPath.row==1){
//                resultCell = [tableView dequeueReusableCellWithIdentifier:@"birthdayCell"];
//                resultCell.textLabel.text = @"Birthday";
//            }
//            break;
//        }
//        case 1:
//        { // ?
//            resultCell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
//            resultCell.textLabel.text = @"request";
//            break;
//        }
//    }

    return resultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0 && indexPath.row==0){
        return [AAProfilePhotoCell cellHeight];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section){
        case 0: return 0;
        default:
            return 44.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section){
        case 0: return nil;
        default: return @"Requests";
    }
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
