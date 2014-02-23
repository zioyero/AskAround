//
//  AAAnswerAskViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class AAPerson;
@class AAAsk;

@interface AAAnswerAskViewController : UIViewController

@property (nonatomic, strong) AAAsk* ask;
@property (nonatomic, strong) AAPerson* fromPerson;
@property (nonatomic, strong) AAPerson* aboutPerson;

- (id)initWithAsk:(AAAsk *)ask;
@end
