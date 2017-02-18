//
//  RegionalPSI.h
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionalPSI : NSObject
@property NSDate *time;
@property NSString *region;
@property NSDictionary *psiValues;
- (NSString *)timeStamp;
@end
