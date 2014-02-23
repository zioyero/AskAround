//
//  AAAnswerAskViewController.m
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAnswerAskViewController.h"
#import "AAPerson.h"
#import "AAAsk.h"
#import "AAAskPersonHeaderView.h"
#import "AAAskMessageView.h"
#import "MMProgressHUD.h"
#import "AAAnswer.h"
#import "AAAskingPersonMessageView.h"
#import "AAAnswersViewController.h"

@interface AAAnswerAskViewController()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *askAboutLabel;
@property (nonatomic, strong) AAAskPersonHeaderView *aboutPersonHeaderView;
@property (nonatomic, strong) AAAskingPersonMessageView *fromPersonHeaderView;

@property (nonatomic, strong) AAAskMessageView *messageView;

//@property (nonatomic, strong) UILabel *addLabel;
//@property (nonatomic, strong) AAAskOptionsView *optionsView;
@property (nonatomic, strong) UIButton *sendButton;


@property (strong, nonatomic) NSArray *contentViewConstraints;

@property (strong, nonatomic) MMProgressHUD *hudView; // the thing that is modal and spinning
@end

@implementation AAAnswerAskViewController



- (id)initWithAsk:(AAAsk*)ask
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.ask = ask;
    }
    return self;
}

- (id)initWithAsk:(AAAsk*)ask andShowResults:(BOOL)showResults
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.showResults = showResults;
        self.ask = ask;
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

- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector
                                                                                           (tappedView:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

-(void)tappedView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if([self.messageView isFirstResponder])
        [self.messageView resignFirstResponder];
}

- (void)createAnswersView{
    if(self.answersViewController)
        return;
    self.answersViewController = [[AAAnswersViewController alloc] initWithAsk:self.ask];
    [self addChildViewController:self.answersViewController];

}
- (void)createViews
{
    self.askAboutLabel = [[UILabel alloc] init];
    self.askAboutLabel.font = [UIFont mediumFontWithSize:14.0];
    self.askAboutLabel.textColor = [UIColor darkerTextColor];
    self.askAboutLabel.text = @"PENDING ASK";
    self.askAboutLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.askAboutLabel];

    self.aboutPersonHeaderView = [[AAAskPersonHeaderView alloc] init];
    self.aboutPersonHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.aboutPersonHeaderView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.aboutPersonHeaderView];

    self.fromPersonHeaderView = [[AAAskingPersonMessageView alloc] initWithAsk:self.ask
                                                                 andFromPerson:nil];
    self.fromPersonHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromPersonHeaderView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.fromPersonHeaderView];

    self.messageView = [[AAAskMessageView alloc] initWithStyle:AAAskMessageViewStyleAnswer];
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.messageView];

//    self.addLabel = [[UILabel alloc] init];
//    self.addLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.addLabel.text = @"ADD";
//    [self.contentView addSubview:self.addLabel];

//    self.optionsView = [[AAAskOptionsView alloc] init];
//    self.optionsView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.optionsView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:self.optionsView];

    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setImage:[UIImage imageNamed:@"Send"] forState:UIControlStateNormal];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.sendButton];

    NSMutableArray *constraints = [NSMutableArray array];

    NSString *vertical = @"V:|-(askAboutT)-[askAbout(askAboutH)]-(askAboutB)-"
            "[aboutPersonHeader(aboutPersonHeaderH)]-2-"
            "[fromPersonHeader(>=fromPersonHeaderH@750)]"
            "-2-[message(messageH)]"
            "-(sendT@900)-[send]-(sendT@900)-[answers(>=400)]-8-|";
    if(!self.showResults)
        self.answersViewController.view.hidden = YES;
    self.answersViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.answersViewController.view];

//    NSString *verticalWithAnswers =
//            @"V:|-(askAboutT)-[askAbout(askAboutH)]-(askAboutB)-"
//            "[aboutPersonHeader(aboutPersonHeaderH)]-2-"
//            "[fromPersonHeader(>=fromPersonHeaderH@750)]"
//            "-2-[message(messageH)]"
//            "-(sendT@900)-[send]";

//    NSString *vertical = @"V:|-(askAboutT)-[askAbout(askAboutH)]-(askAboutB)-"
//            "[personHeader(personHeaderH)]-2-[message(messageH)]"
//            "-(askAboutT)-[addLabel(askAboutH)]-(askAboutB)-"
//            "[options(optionsH)]-(sendT@900)-[send]";
    NSDictionary *views = @{
            @"askAbout": self.askAboutLabel,
            @"aboutPersonHeader": self.aboutPersonHeaderView,
            @"fromPersonHeader": self.fromPersonHeaderView,
            @"message": self.messageView,
            @"answers": self.answersViewController.view,
//            @"addLabel": self.addLabel,
//            @"options": self.optionsView,
            @"send": self.sendButton,
    };
    NSDictionary *vMetrics = @{
            @"askAboutH": @(36.0f),
            @"askAboutT": @(12.0f),
            @"askAboutB": @(8.0f),
            @"aboutPersonHeaderH": @(44.0f),
            @"fromPersonHeaderH": @(44.0f), // intrinsic
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
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[aboutPersonHeader]-0-|"
                                                                             options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[fromPersonHeader]-0-|"
                                                                             options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[message]-0-|"
                                                                             options:0 metrics:nil views:views]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(labelPad)-[addLabel]-"
//            "(labelPad)-|"
//                  options:0 metrics:hMetrics views:views]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[options]-0-|"
//                  options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[answers]-0-|"
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
//    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.sendButton
//                                                                        attribute:NSLayoutAttributeBottom
//                            relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView
//                            attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-48.0f];
//    bottomConstraint.priority = 500;
//    [constraints addObject:bottomConstraint];

    [self.contentView addConstraints:constraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@", self.ask.title ? self.ask.title : @"Idea"];

    [self createAnswersView];
    [self createScrollview];
    [self createViews];
    [self addGestureRecognizer];


    self.sendButton.enabled = NO;

    @weakify(self);
    [RACObserve(self.messageView, hasValidBody) subscribeNext:^(id x) {
        @strongify(self);
        self.sendButton.enabled = [x boolValue];
    }];

    [AAPerson findPeopleWithFacebookIDs:@[self.ask.aboutPersonID, self.ask.fromPersonID
    ] withBlock:^(NSArray *people, NSError *error) {
        @strongify(self);
        for (AAPerson *p in people){
            if([p.facebookID isEqualToString:self.ask.aboutPersonID]){
                self.aboutPersonHeaderView.person = p;
                self.aboutPerson = p;
            }
            else if ([p.facebookID isEqualToString:self.ask.fromPersonID]){
                self.fromPersonHeaderView.fromPerson = p;
                self.fromPerson = p;
            }
        }
    }];

    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(id x) {
                @strongify(self);
                NSLog(@"button clicked");
                AAAnswer *answer = [[AAAnswer alloc] initWithBody:[self.messageView messageBody]
                                                         andExtra:nil forAsk:self.ask];
                [AAAnswer postAnswer:answer forAsk:self.ask];
//                [AAAsk sendOutAsk:ask aboutPerson:self.aboutPerson];
                RACSignal *first = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [MMProgressHUD showWithTitle:@"Sending"];
                    [subscriber sendCompleted];
                    return nil;
                }];
                RACSignal *third = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [MMProgressHUD showWithTitle:@"Sent!" status:nil image:[UIImage imageNamed:@"CheckMark"]];
                    [subscriber sendCompleted];
                    return nil;
                }];
                RACSignal *fourth = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [MMProgressHUD dismiss];
                    [subscriber sendCompleted];
                    return nil;
                }];
                NSArray *signals = @[[first delay:5.0] , /*[second delay:1.0f], */[third delay:3.0], [fourth delay:0.2] ];
                [[RACSignal concat:signals] subscribeCompleted:^{
                    NSLog(@"Done!");
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
