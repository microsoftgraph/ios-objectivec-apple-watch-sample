/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NSString*)accessToken;
+ (void)setAccessToken:(NSString*)newAccessToken;
+ (NSMutableURLRequest *)getRequest: (NSString*) requestURL;

@end
