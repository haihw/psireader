//
//  BackendConnector.h
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackendConnector : NSObject
+(id)sharedConnector;

- (void)getPSIForDateTime:(NSDate *)dateTime
                 response:(void (^)(BOOL success, NSString *message, id result))block;
@end
