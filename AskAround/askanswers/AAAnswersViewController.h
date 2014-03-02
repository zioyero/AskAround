//
//  AAAnswersViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class AAAnswersModelView;
@class AAAsk;

/**
* ViewController that shows only the answers to an ask
*/
@interface AAAnswersViewController : UITableViewController

@property (nonatomic, strong) AAAnswersModelView * answerModelView;

- (id)initWithAsk:(AAAsk *)ask;

- (id)initWithAsk:(AAAsk *)ask withAnswers:(NSArray *)answers;
@end
