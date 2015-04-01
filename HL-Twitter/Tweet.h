//
//  TwitterPost.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (assign, nonatomic) NSUInteger objectId;
@property (strong, nonatomic) NSString *objectIdString;
@property (strong, nonatomic) NSString *text;

- (id)initWithJSON:(NSDictionary *)JSON;

@end
