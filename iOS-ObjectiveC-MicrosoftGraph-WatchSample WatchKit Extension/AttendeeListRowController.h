/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface AttendeeListRowController : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceImage *profilePicture;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *attendeeLabel;

@end
