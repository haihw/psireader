//
//  LandingViewController.h
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lbDateTime;
@property (strong, nonatomic) IBOutlet UITableView *tablePSIResult;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
- (IBAction)btnRefreshTapped:(id)sender;

@end
