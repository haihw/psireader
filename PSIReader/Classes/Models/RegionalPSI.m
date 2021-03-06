//
//  RegionalPSI.m
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import "RegionalPSI.h"
@interface NSObject (NSCoding)

- (id)initWithCoder:(NSCoder *)decoder;

- (void)encodeWithCoder:(NSCoder *)encoder;

@end


@implementation NSObject (NSCoding)
- (id)initWithCoder:(NSCoder *)decoder {
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
}
@end

@implementation RegionalPSI
- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.time = [decoder decodeObjectForKey:@"time"];
        self.region = [decoder decodeObjectForKey:@"region"];
        self.psiValues = [decoder decodeObjectForKey:@"psiValues"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.region forKey:@"region"];
    [encoder encodeObject:self.psiValues forKey:@"psiValues"];
}
- (NSString *)timeStamp{
    if (self.time){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        NSString *dateTimeString = [dateFormatter stringFromDate:self.time];
        return dateTimeString;
    }
    return @"";
}
@end
