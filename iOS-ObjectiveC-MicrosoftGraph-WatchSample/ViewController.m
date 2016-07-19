/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "AuthenticationManager.h"
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) WCSession *session;

@end

@implementation ViewController

// You will set your application's clientId and redirect URI.
NSString * const kRedirectUri = @"ENTER_YOUR_REDIRECT_URI";
NSString * const kClientId    = @"ENTER_YOUR_CLIENT_ID";

NSString * const kAuthority   = @"https://login.microsoftonline.com/common";
NSString * const kResourceId  = @"https://graph.microsoft.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([WCSession isSupported]){
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
    
}
- (IBAction)connect:(id)sender {
    [self performConnect];
}

- (void)performConnect {
    
    AuthenticationManager *authManager = [AuthenticationManager sharedInstance];
    
    [authManager initWithAuthority:kAuthority clientID:kClientId redirectURI:kRedirectUri resourceID:kResourceId completion:^(ADAuthenticationError *error) {
        
        if (error) {
            NSLog(@"Issue authenticating with the service");
        }

        else {
            [authManager acquireAuthTokenCompletion:^(ADAuthenticationError *acquireTokenError) {
                if (acquireTokenError) {
                    NSLog(@"Error acquiring token");
                }

                else{
                    NSString *accessToken = authManager.accessToken;
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:accessToken forKey:@"token"];
                    
                    //Pass the access token over to WatchKit Extension project
                    if (self.session.isReachable) {
                        [self.session sendMessage:dict replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                        } errorHandler:^(NSError * _Nonnull error) {
                            NSLog(@"%@", error.localizedDescription);
                        }];
                    }
                    
                    else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }
            }];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)session: (nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
}

- (void)session: (nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error{
}

- (void)sessionDidDeactivate:(WCSession *)session {
    
    [[WCSession defaultSession] activateSession];
    
}


-(void) sessionDidBecomeInactive:(WCSession *)session {
    
}

@end
