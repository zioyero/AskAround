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
#import "AAAsk.h"
#import "AACreateAskViewController.h"
#import "AAAnswerAskViewController.h"

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
        self.title = @"Me";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me"
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

    [RACObserve(self.profileModelView, person) subscribeNext:^(id x)
    {
       @strongify(self);
        [self.view setNeedsDisplay];
    }];

    [[self rac_signalForSelector:@selector(buttonCell:clicked:)
                    fromProtocol:@protocol(AAButtonCellDelegate)] subscribeNext:^(RACTuple *value) {
        @strongify(self);
        UITableViewCell *cell = [value objectAtIndex:0];
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        NSLog(@"button clicked %@", path);
        if([self.profileModelView showFriendsListViewControllerForClickAt:path])
        {
            if(!self.friendsListViewController){
                AAFriendsListViewController *viewController = [[AAFriendsListViewController alloc] init];
                self.friendsListViewController = viewController;
            }
            [self.navigationController pushViewController:self.friendsListViewController animated:YES];
        }
        else if([self.profileModelView showCreateAskForClickAt:path]){
            AAPerson *person = self.profileModelView.person;
            AACreateAskViewController *viewController = [[AACreateAskViewController alloc] initWithAboutPerson:person];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else{
            // TEST BUTTON????
            NSLog(@"Test Button Pushed");
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

        if(!self.profileModelView.person){
            AAPerson *person = [AAPerson currentUser];
            self.profileModelView.person = person;
        }
        [self.profileModelView refreshPerson];
    }
    else{
        [self.profileModelView refreshPerson];
    }
}

- (void)reloadProfile
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont mediumFontWithSize:15.0f];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"%@", self.profileModelView.person.name];

    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

//    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.profileModelView.person.name];

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

        NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:
                [UIFont lightItalicStringAttributesWithSize:12.0 withColor:[UIColor lighterTextColor]]];
        resultCell.textLabel.attributedText = string;
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text = [self.profileModelView headerTitleForSection:section];
    if(text){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor backgroundGrayColor];
        UILabel * label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:label];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-16-[label]-(>=16)-|"
                                                                     options:0
                                                                     metrics:nil views:@{@"label": label}]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[label]"
                                                                     options:0
                                                                     metrics:nil views:@{@"label": label}]];
        label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[UIFont
                boldStringAttributesWithSize:13.0 withColor:[UIColor darkerTextColor]]];
        return view;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.profileModelView willSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.profileModelView objectAtIndexPath:indexPath];
    if([object isKindOfClass:[AAAsk class]]){
        AAAnswerAskViewController *viewController = [[AAAnswerAskViewController alloc] initWithAsk:(AAAsk *)object];
        [self.navigationController pushViewController:viewController animated:YES];
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
