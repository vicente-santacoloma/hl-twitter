//
//  TwitterAPI.m
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import "TwitterAPI.h"

//#define kScreenName @"HLInvest"
#define kScreenName @"ElNacionalWeb"

#define kConsumerkey    @"6RToSDn8Q5HFf1UYGB2H2UFv5"
#define kConsumerSecret @"1Zk8kQM4ESs2ice3EpAolbNcNQbaBXGA6SAaLj0Qr87pkQfDpP"

@implementation TwitterAPI

- (id)init
{
  self = [super init];
  if (self) {
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:kConsumerkey
                                                   consumerSecret:kConsumerSecret];
    //self.tweets = [[NSMutableSet alloc] init];
    self.tweets = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)fetchUserAccount
{
  [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
    
    [self.twitter getUserInformationFor:kScreenName successBlock:^(NSDictionary *user) {
      
      self.userAccount = [[TwitterUserAccount alloc] initWithJSON:user];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"TwitterUserAccountFinishedFetching" object:nil];
      
    } errorBlock:^(NSError *error) {
      NSLog(@"%@", error.debugDescription);
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"TwitterUserAccountFailedFetching" object:nil];
    }];
    
  } errorBlock:^(NSError *error) {
    NSLog(@"%@", error.debugDescription);
  }];
}

- (void)fetchTweetsWithSinceID:(NSString *)sinceID maxID:(NSString *)maxID count:(NSUInteger)count
{
  [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
    
    [self.twitter getUserTimelineWithScreenName:kScreenName sinceID:sinceID maxID:maxID count:count
                                   successBlock:^(NSArray *statuses) {
                          
      self.numberOfNewTweets = statuses.count;
                                    
      for (NSDictionary *tweetDictionary in statuses) {
        //[self.tweets addObject:[[Tweet alloc] initWithJSON:tweetDictionary]];
        [self.tweets addObject:[[Tweet alloc] initWithJSON:tweetDictionary]];
      }
                                     
      [[NSNotificationCenter defaultCenter] postNotificationName:@"TweetsFinishedFetching" object:nil];
                                     
    } errorBlock:^(NSError *error) {
      NSLog(@"%@", error.debugDescription);
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"TweetsFailedFetching" object:nil];
    }];
     
  } errorBlock:^(NSError *error) {
    NSLog(@"%@", error.debugDescription);
  }];
}

@end
