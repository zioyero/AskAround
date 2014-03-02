//
//  AAAnswerAskViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class AAPerson;
@class AAAsk;
@class AAAnswersViewController;

/**
* ViewController to REPLY to an ask
*/
@interface AAAnswerAskViewController : UIViewController

@property (nonatomic, strong) AAAsk* ask;
@property (nonatomic, strong) AAPerson* fromPerson;
@property (nonatomic, strong) AAPerson* aboutPerson;
@property (nonatomic, assign) BOOL showResults;
@property (nonatomic, strong) AAAnswersViewController * answersViewController;

- (id)initWithAsk:(AAAsk *)ask;

- (id)initWithAsk:(AAAsk *)ask andShowResults:(BOOL)showResults;

@end
