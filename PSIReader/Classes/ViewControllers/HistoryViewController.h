//
//  HistoryViewController.h
//  PSIReader
//
//  Created by Hai Hw on 19/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *psiRecords;
- (IBAction)btnBackTapped:(id)sender;

@end
