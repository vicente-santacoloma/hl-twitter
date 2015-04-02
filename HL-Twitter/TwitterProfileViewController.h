//
//  ViewController.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

