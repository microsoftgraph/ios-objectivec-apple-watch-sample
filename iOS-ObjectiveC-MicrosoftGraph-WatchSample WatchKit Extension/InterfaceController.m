/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "AttendeeListController.h"
#import "EventTableRowController.h"
#import "InterfaceController.h"
#import "NetworkManager.h"


@interface InterfaceController()
@property (strong, nonatomic) WCSession *session;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *eventTable;
@property (strong, nonatomic) NSArray *calendarEvents;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *loadingLabel;
@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.

    if ([WCSession isSupported]){
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    [self.loadingLabel setHidden:true];
    if([NetworkManager accessToken] !=nil) {
        [self getEvents];
    }
    else {
        NSLog(@"Please log in to the app on the phone.");
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// Retrieves a selection of current calendar events and populates the UI
-(void)getEvents {
    [self.loadingLabel setHidden:false];
    NSString *path =[NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/events"];
    NSMutableURLRequest *request = [NetworkManager getRequest:path];
    NSURLSession *getSession = [NSURLSession sharedSession];
    [[getSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id calendarResults = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        self.calendarEvents = [calendarResults objectForKey:@"value"];
        
        [self.eventTable setNumberOfRows: self.calendarEvents.count withRowType:@"eventRow"];
        
        [self.calendarEvents enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *calendarEventName = [object objectForKey:@"subject"];
            EventTableRowController *eventController = [self.eventTable rowControllerAtIndex:idx];
            eventController.eventSubject.text = calendarEventName;
            [self.loadingLabel setHidden:true];
            
        }];
    }] resume];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    [self pushControllerWithName:@"attendeeListController" context:self.calendarEvents[rowIndex]];
}


#pragma mark - WCSession Delegates

//Retrieves and stores access token from the iOS app authentication process.
//Populates UI with a recent selection of calendar events.
- (void)session: (nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    [NetworkManager setAccessToken:[message valueForKey:@"token"]];
    [self getEvents];
}

- (void)session: (nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error{
}

- (void)sessionDidDeactivate:(WCSession *)session {
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
}

@end



