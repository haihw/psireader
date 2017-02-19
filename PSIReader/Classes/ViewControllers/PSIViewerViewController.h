//
//  PSIViewerViewController.h
//  PSIReader
//
//  Created by Hai Hw on 19/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSIViewerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *labelTop;

- (IBAction)btnBackTapped:(id)sender;
@property NSArray *psiInfos;
@end
