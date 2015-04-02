//
//  TwitterAPI.h
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models
#import "Tweet.h"
#import "TwitterUserAccount.h"

// Pods
#import "STTwitter.h"

// Notifications
#define kUserInformationFetchSucceedNotificationName    @"UserInformationFetchSucceedNotification"
#define kUserInformationFetchFailedNotificationName     @"UserInformationFetchFailedNotification"
#define kUserTimelineFetchSucceedNotificationName       @"UserTimelineFetchSucceedNotification"
#define kUserTimelineFetchFailedNotificationName        @"UserTimelineFetchFailedNotification"

@interface TwitterClient : NSObject

@property (strong, nonatomic) STTwitterAPI *twitter;

@property (strong, nonatomic) NSString *maxID;
@property (strong, nonatomic) NSString *sinceID;

@property (strong, nonatomic) TwitterUserAccount *userAccount;
@property (strong, nonatomic) NSMutableArray *tweets;

@property (assign, nonatomic) NSUInteger numberOfNewTweets;

/**
 Fetches the information of a Twitter user account.
 */
- (void)fetchUserInformation;

/**
 Fetches the user timeline of a Twitter user account using the given parameters.
 
 @param sinceID An ID to be used to return tweets with an ID greater than the specified ID. This 
  parameter is optional.
 @param maxID An ID to be used to return tweets with an ID less or equal to the specified ID. This 
  parameter is optional.
 @param count Number of tweets to be fetched.
 */
- (void)fetchUserTimelineWithSinceID:(NSString *)sinceID maxID:(NSString *)maxID count:(NSUInteger)count;

@end
