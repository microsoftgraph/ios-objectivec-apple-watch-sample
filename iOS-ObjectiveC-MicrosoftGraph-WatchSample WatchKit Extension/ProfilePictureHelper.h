/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "Attendee.h"
#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>


@interface ProfilePictureHelper : NSObject
+ (void)getPhotoForAttendee:(Attendee *)attendee withCompletion:(void (^)(UIImage *image, NSError *error))completion;

@end
