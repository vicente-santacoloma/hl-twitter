//
//  TwitterUserAccount.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class abstracts the information needed of a twitter user account.
 */
@interface TwitterUserAccount : NSObject

@property (assign, nonatomic) NSUInteger objectId;
@property (strong, nonatomic) NSString *objectIdString;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *profileImageURLHTTPS;

/**
 Initialises a twitter user account using the JSON information contained in a dictionary structure.
 
 @param JSON A dictionary containing the JSON information corresponding to a twitter user account.
 
 @return The initialised twitter user account.
 */
- (id)initWithJSON:(NSDictionary *)JSON;

@end
