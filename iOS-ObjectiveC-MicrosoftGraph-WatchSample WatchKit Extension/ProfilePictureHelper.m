/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "Attendee.h"
#import "NetworkManager.h"
#import "ProfilePictureHelper.h"
#import <WatchKit/WatchKit.h>

@implementation ProfilePictureHelper

// Retrieves profile picture (if there is one) for meeting attendees and their direct reports.
+ (void)getPhotoForAttendee:(Attendee *)attendee withCompletion:(void (^)(UIImage *image, NSError *error))completion {

    NSString *path =[NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/users/%@/Photo/$value", attendee.emailAddress];
    NSMutableURLRequest *request = [NetworkManager getRequest:path];

    NSURLSession *getSession = [NSURLSession sharedSession];
    [[getSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        }
        else {
    UIImage *image = [UIImage imageWithData:data];
            completion(image, nil);
        }
    }] resume];
}

@end
