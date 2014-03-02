//
//  AACreateAskViewController.h
//  AskAround
//
//  Created by Agathe Battestini on 2/23/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//



@class AAPerson;

/**
* ViewController when creating an ask
*/
@interface AACreateAskViewController : UIViewController

@property (nonatomic, strong)AAPerson *aboutPerson;

- (id)initWithAboutPerson:(AAPerson *)aboutPerson;
@end
