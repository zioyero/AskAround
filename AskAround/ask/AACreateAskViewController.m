//
//  AACreateAskViewController.m
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AACreateAskViewController.h"
#import "AAPerson.h"
#import "AAAskMessageView.h"
#import "AAAskPersonHeaderView.h"
#import "AAAskOptionsView.h"

@interface AACreateAskViewController ()


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *askAboutLabel;
@property (nonatomic, strong) AAAskPersonHeaderView *personHeaderView;
@property (nonatomic, strong) AAAskMessageView *messageView;

@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) AAAskOptionsView *optionsView;
@property (nonatomic, strong) UIButton *sendButton;

//@property (nonatomic, strong) UIButton *previewButton;

@property (strong, nonatomic) NSArray *contentViewConstraints;
@end

@implementation AACreateAskViewController



- (id)initWithAboutPerson:(AAPerson*)aboutPerson
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.aboutPerson = aboutPerson;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)createScrollview
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.backgroundColor = [UIColor backgroundGrayColor];
    [self.view addSubview:self.scrollView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:@{@"scrollView": self.scrollView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:@{@"scrollView": self.scrollView}]];

    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[self]|" options:0 metrics:0 views:@{@"self": self.contentView}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:0 views:@{@"self": self.contentView}]];

    NSLayoutConstraint *constHeight = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:1.0];
    constHeight.priority = UILayoutPriorityDefaultHigh;
    [self.view addConstraint:constHeight];

    NSLayoutConstraint *constHeightGrowing = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:1.0];
    constHeight.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:constHeightGrowing];

    // in content view
    if (self.contentViewConstraints.count>0) {
        [self.contentView removeConstraints:self.contentViewConstraints];
    }


}

- (void)createViews
{
    self.askAboutLabel = [[UILabel alloc] init];
    self.askAboutLabel.text = @"ASK ABOUT";
    self.askAboutLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.askAboutLabel];

    self.personHeaderView = [[AAAskPersonHeaderView alloc] init];
    self.personHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.personHeaderView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.personHeaderView];

    self.messageView = [[AAAskMessageView alloc] init];
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.messageView];

    self.addLabel = [[UILabel alloc] init];
    self.addLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.addLabel.text = @"ADD";
    [self.contentView addSubview:self.addLabel];

    self.optionsView = [[AAAskOptionsView alloc] init];
    self.optionsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.optionsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.optionsView];

    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setImage:[UIImage imageNamed:@"Send"] forState:UIControlStateNormal];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.sendButton];

    NSMutableArray *constraints = [NSMutableArray array];

    NSString *vertical = @"V:|-(askAboutT)-[askAbout(askAboutH)]-(askAboutB)-"
            "[personHeader(personHeaderH)]-2-[message(messageH)]"
            "-(askAboutT)-[addLabel(askAboutH)]-(askAboutB)-"
            "[options(optionsH)]-(sendT@900)-[send]";
    NSDictionary *views = @{
            @"askAbout": self.askAboutLabel,
            @"personHeader": self.personHeaderView,
            @"message": self.messageView,
            @"addLabel": self.addLabel,
            @"options": self.optionsView,
            @"send": self.sendButton,
    };
    NSDictionary *vMetrics = @{
            @"askAboutH": @(36.0f),
            @"askAboutT": @(12.0f),
            @"askAboutB": @(8.0f),
            @"personHeaderH": @(44.0f),
            @"messageH": @(200.0f),
            @"optionsH": @(44.0f),
            @"sendT": @(16.0f),
            @"sendB": @(24.0f),
    };

    NSDictionary *hMetrics = @{
            @"labelPad": @(24.0f),
    };


    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(labelPad)-[askAbout]-(labelPad)-|"
                  options:0 metrics:hMetrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[personHeader]-0-|"
                  options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[message]-0-|"
                  options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(labelPad)-[addLabel]-"
            "(labelPad)-|"
                  options:0 metrics:hMetrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[options]-0-|"
                  options:0 metrics:nil views:views]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.sendButton
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0 constant:0.0]];
    // vertical
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vertical
                             options:0 metrics:vMetrics views:views]];

    // last element
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                        attribute:NSLayoutAttributeBottom
                            relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView
                            attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-48.0f];
    bottomConstraint.priority = 500;
    [constraints addObject:bottomConstraint];
    [self.contentView addConstraints:constraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Ask About";

    [self createScrollview];
    [self createViews];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
