/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>
#import "ADAuthenticationContext.h"


@interface AuthenticationManager : NSObject

+(AuthenticationManager*)sharedInstance;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *userID;

-(void)initWithAuthority:(NSString *)authority
                clientID:(NSString *)clientID
             redirectURI:(NSString *)redirectURI
              resourceID:(NSString *)resourceID
              completion:(void (^)(ADAuthenticationError *error))completion;

-(void) acquireAuthTokenCompletion:(void (^)(ADAuthenticationError *error))completion;

-(void)acquireAuthTokenWithResource:(NSString *)resourceID
                            clientID:(NSString *)clientID
                         redirectURI:(NSURL*)redirectURI
                          completion:(void (^)(ADAuthenticationError *error))completion;


@end
