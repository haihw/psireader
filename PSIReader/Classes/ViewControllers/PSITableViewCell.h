//
//  PSITableViewCell.h
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSITableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbRegion;
@property (strong, nonatomic) IBOutlet UILabel *lbPSI24;
@property (strong, nonatomic) IBOutlet UILabel *lbPSI3;

@end
