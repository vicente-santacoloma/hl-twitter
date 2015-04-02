//
//  TwitterPost.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  This class abstracts the information needed of a tweet.
 */
@interface Tweet : NSObject

@property (assign, nonatomic) NSUInteger objectId;
@property (strong, nonatomic) NSString *objectIdString;
@property (strong, nonatomic) NSString *text;

/**
 Initialises a tweet using the JSON information contained in a dictionary structure.
 
 @param JSON A dictionary containing the JSON information corresponding to a tweet.
 
 @return The initialised tweet.
 */
- (id)initWithJSON:(NSDictionary *)JSON;

@end
