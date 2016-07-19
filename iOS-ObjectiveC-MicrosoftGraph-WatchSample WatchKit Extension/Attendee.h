/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>

@interface Attendee : NSObject

@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *jobTitle;

@end
