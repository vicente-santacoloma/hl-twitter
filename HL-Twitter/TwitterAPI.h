//
//  TwitterAPI.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STTwitter.h"

#import "TwitterUserAccount.h"
#import "Tweet.h"

@interface TwitterAPI : NSObject

@property (strong, nonatomic) STTwitterAPI *twitter;
@property (strong, nonatomic) TwitterUserAccount *userAccount;
//@property (strong, nonatomic) NSMutableSet *tweets;

@property (assign, nonatomic) NSUInteger numberOfNewTweets;

@property (strong, nonatomic) NSMutableArray *tweets;

- (void)fetchUserAccount;

- (void)fetchTweetsWithSinceID:(NSString *)sinceID maxID:(NSString *)maxID count:(NSUInteger)count;

@end
