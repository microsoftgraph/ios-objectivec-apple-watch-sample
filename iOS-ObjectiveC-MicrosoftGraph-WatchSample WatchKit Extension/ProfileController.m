/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "Attendee.h"
#import "AttendeeListController.h"
#import "DirectsTableRowController.h"
#import "NetworkManager.h"
#import "ProfileController.h"
#import "ProfilePictureHelper.h"


@interface ProfileController()

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *attendeeName;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *jobTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *managerName;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *directs;
@property (strong, nonatomic) Attendee *attendee;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *directsTable;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *loadingLabel;

@end

@implementation ProfileController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    self.attendee = (Attendee*)context;
    self.attendeeName.text = self.attendee.name;
    [self.loadingLabel setHidden:false];
    [self getUserManager];
    [self getUserDirects];
    
}

#pragma mark - Retrieve user manager and their direct reports

//Retrieves the selected attendee's manager (if they have one)
- (void)getUserManager {
    [self.loadingLabel setHidden:false];
    NSString *path =[NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/users/%@/manager", self.attendee.emailAddress];
    NSMutableURLRequest *request = [NetworkManager getRequest:path];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        else {
            id userManager = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
            NSString *managerName = [userManager objectForKey:@"displayName"];
            self.managerName.text = [NSString stringWithFormat:@"Manager: %@", managerName];
        }
    }]resume];
}

//Retrieves the selected attendee's direct reports (if they have them) idisplay direct profile picture
- (void)getUserDirects {
    NSString *path =[NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/users/%@/directReports", self.attendee.emailAddress];
    NSMutableURLRequest *request = [NetworkManager getRequest:path];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    id userDirectReports = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
        if (error) {
          NSLog(@"%@", error.localizedDescription);
        }
        
        else {
            NSArray *directReports = [userDirectReports objectForKey:@"value"];
            [self.directsTable setNumberOfRows:directReports.count withRowType:@"directsRow"];
            
            [directReports enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
                Attendee *attendee = [[Attendee alloc] init];
                attendee.emailAddress = [object objectForKey:@"mail"];
                attendee.displayName = [object objectForKey:@"displayName"];
                attendee.jobTitle = [object objectForKey:@"jobTitle"];
                DirectsTableRowController *rowController = [self.directsTable rowControllerAtIndex:idx];
                rowController.directsName.text = attendee.displayName;
                self.jobTitle.text = attendee.jobTitle;
                
                [ProfilePictureHelper getPhotoForAttendee:attendee withCompletion:^(UIImage *image, NSError *error) {
                    [rowController.profilePicture setImage:image];
                }];
                [self.loadingLabel setHidden:true];
            }];
        }
    }]resume];
}

@end
