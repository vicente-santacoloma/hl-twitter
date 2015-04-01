//
//  TwitterUserAccount.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterUserAccount : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *profileImageURLHTTPS;

- (id)initWithJSON:(NSDictionary *)JSON;

@end
