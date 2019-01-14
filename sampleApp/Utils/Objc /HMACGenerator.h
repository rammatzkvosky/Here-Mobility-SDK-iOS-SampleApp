/***************************************************************
 * Copyright © 2017 HERE Global B.V. All rights reserved. *
 **************************************************************/

#import <Foundation/Foundation.h>

@interface HMACGenerator : NSObject

+ (NSString *)hmacSHA256From:(NSString*)appKey userId:(NSString *)userId expiration:(int32_t)expiration withKey:(NSString *)key;

@end
