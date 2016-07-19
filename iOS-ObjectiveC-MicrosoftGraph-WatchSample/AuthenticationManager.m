/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "AuthenticationManager.h"
#import <ADAuthenticationContext.h>



@interface AuthenticationManager()

@property (nonatomic, strong) NSString *authority;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *redirectUri;
@property (nonatomic, strong) NSString *resourceID;
@property (nonatomic, strong) ADAuthenticationContext *context;

@end

@implementation AuthenticationManager

#pragma mark - singleton

+ (AuthenticationManager *)sharedInstance {
    static AuthenticationManager *sharedInstance;
    static dispatch_once_t onceToken;
    
    //Initialize the AuthenticationManager only once.
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AuthenticationManager alloc] init];
        
    });
    return sharedInstance;
}

#pragma mark - init
- (void)initWithAuthority:(NSString *)authority
                clientID:(NSString *)clientID
             redirectURI:(NSString *)redirectURI
              resourceID:(NSString *)resourceID
              completion:(void (^)(ADAuthenticationError *error))completion
{
    ADAuthenticationError *error;
    _context = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    
    if(error) {
        //Log error
        completion(error);
    }
    
    else {
        self.clientID = clientID;
        self.redirectUri = redirectURI;
        self.authority = authority;
        self.resourceID = resourceID;
        
        completion(nil);
    }
}

#pragma mark - acquire token
- (void)acquireAuthTokenCompletion:(void (^)(ADAuthenticationError *error))completion {
    [self acquireAuthTokenWithResource:self.resourceID
                              clientID:self.clientID
                           redirectURI: [NSURL URLWithString:self.redirectUri]
                            completion:^(ADAuthenticationError *error) {
                                completion(error);
                            }];
}

- (void)acquireAuthTokenWithResource:(NSString *)resourceID
                            clientID:(NSString *)clientID
                         redirectURI:(NSURL *)redirectURI
                          completion:(void (^)(ADAuthenticationError *error))completion {
    
    [self.context acquireTokenWithResource:resourceID
                                  clientId:clientID
                               redirectUri:redirectURI
                           completionBlock:^(ADAuthenticationResult *result) {
                               
                               if (result.status !=AD_SUCCEEDED) {
                                   completion(result.error);
                               }
                               
                               else{
                                   self.accessToken = result.accessToken;
                                   self.userID = result.tokenCacheStoreItem.userInformation.userId;
                                   completion(nil);
                               }
                           }];
}

@end
