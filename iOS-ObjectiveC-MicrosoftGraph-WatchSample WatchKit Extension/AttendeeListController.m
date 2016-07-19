/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "AttendeeListController.h"
#import "AttendeeListRowController.h"
#import "Attendee.h"
#import "NetworkManager.h"
#import "ProfilePictureHelper.h"

@interface AttendeeListController() 

@property (readwrite) id selectedEvent;
@property (strong, nonatomic) NSMutableArray *attendees;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *attendeeListTable;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *loadingLabel;

@end

@implementation AttendeeListController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    self.selectedEvent = context;
    [self getEventAttendees];
}

#pragma mark - Populate UI with Event Attendees and Profile Pictures

//Retrieves a selection of attendees from the selected event and populates the results in the UI.
- (void) getEventAttendees {
    [self.loadingLabel setHidden:false];

    if (!self.attendees) {
    self.attendees= [NSMutableArray new];
    }

    [self.attendees removeAllObjects];

    NSArray *attendeesList= [self.selectedEvent objectForKey:@"attendees"];
    [self.attendeeListTable setNumberOfRows: attendeesList.count withRowType:@"attendeeRow"];
    [attendeesList enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        id emailAddress= [object objectForKey:@"emailAddress"];
        
        Attendee *attendee= [[Attendee alloc] init];
        attendee.emailAddress= [emailAddress objectForKey:@"address"];
        attendee.name= [emailAddress objectForKey:@"name"];
        
        AttendeeListRowController *rowController = [self.attendeeListTable rowControllerAtIndex:idx];
        rowController.attendeeLabel.text= attendee.name;
        
        [self.attendees addObject:attendee];
        
        [ProfilePictureHelper getPhotoForAttendee:attendee withCompletion:^(UIImage *image, NSError *error) {
            [rowController.profilePicture setImage:image];
            [self.loadingLabel setHidden:true];
            
        }];
    }];
}

// Pass attendee over to the profile controller
- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    [self pushControllerWithName:@"profileController" context:self.attendees[rowIndex]];
}


@end
