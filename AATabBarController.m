//
//  AATabBarController.m
//  AskAround
//
//  Created by Scott Shebby on 2/22/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AATabBarController.h"

@interface AATabBarController ()

@property(nonatomic) UIButton * leftButton;
@property(nonatomic) UIButton * rightButton;

@end

@implementation AATabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect r = self.tabBar.frame;
    r.origin.y --;
    r.size.height ++;
    
    UIView * cover = [[UIView alloc] initWithFrame:r];
    cover.layer.borderColor = [UIColor clearColor].CGColor;
    
    cover.backgroundColor = [UIColor colorWithRed:242./255. green:242/255. blue:242./255. alpha:1.0];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.tabBar.frame.size.height)];
    [self.leftButton setImage:[UIImage imageNamed:@"TabHomeSelected"] forState:UIControlStateNormal];

    [self.leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];

    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.tabBar.frame.size.height)];
    [self.rightButton setImage:[UIImage imageNamed:@"TabFriends"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:self.rightButton];
    [cover addSubview:self.leftButton];

    cover.clipsToBounds = NO;
    cover.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    cover.layer.shadowOffset = CGSizeMake(0, -5);
    cover.layer.shadowOpacity = 0.5;
    cover.layer.shadowRadius = 3.0;
    
    [self.view addSubview:cover];
    [self.view bringSubviewToFront:cover];
    
}

- (void) leftButtonTap:(id)sender
{
    self.selectedIndex = 0;
    [self.leftButton setImage:[UIImage imageNamed:@"TabHomeSelected"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"TabFriends"] forState:UIControlStateNormal];

}
- (void) rightButtonTap:(id)sender
{
    self.selectedIndex = 1;
    [self.leftButton setImage:[UIImage imageNamed:@"TabHome"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"TabFriendsSelected"] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
