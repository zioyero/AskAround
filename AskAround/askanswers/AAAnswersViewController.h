//
//  AAAnswersViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class AAAnswersModelView;
@class AAAsk;

@interface AAAnswersViewController : UITableViewController

@property (nonatomic, strong) AAAnswersModelView * answerModelView;

- (id)initWithAsk:(AAAsk *)ask;
@end
