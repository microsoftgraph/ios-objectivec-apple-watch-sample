/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "NetworkManager.h"

@implementation NetworkManager: NSObject

static NSString *myAccessToken;

//Store access token
+ (NSString *)accessToken {
    if (myAccessToken == nil) {
    }
    return myAccessToken;
}

+ (void)setAccessToken:(NSString *)newAccessToken {
    myAccessToken = newAccessToken;
}

//Helper method to build requests in InterfaceController, AttendeeListController
//ProfileController
+ (NSMutableURLRequest *)getRequest: (NSString*) requestURL {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];

    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", [NetworkManager accessToken]];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];

    return request;
}

@end
