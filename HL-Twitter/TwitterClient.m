//
//  TwitterAPI.m
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import "TwitterClient.h"

//#define kScreenName     @"HLInvest"
#define kScreenName     @"ElNacionalWeb"
#define kConsumerkey    @"6RToSDn8Q5HFf1UYGB2H2UFv5"
#define kConsumerSecret @"1Zk8kQM4ESs2ice3EpAolbNcNQbaBXGA6SAaLj0Qr87pkQfDpP"

@implementation TwitterClient

- (id)init
{
  self = [super init];
  if (self) {
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:kConsumerkey
                                                   consumerSecret:kConsumerSecret];
    self.tweets = [[NSMutableArray alloc] init];
    self.maxID = nil;
    self.sinceID = nil;
  }
  return self;
}

- (void)fetchUserInformation
{
  [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
    
    [self.twitter getUserInformationFor:kScreenName successBlock:^(NSDictionary *user) {
      
      self.userAccount = [[TwitterUserAccount alloc] initWithJSON:user];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserInformationFetchSucceedNotificationName
                                                          object:nil];
      
    } errorBlock:^(NSError *error) {
      NSLog(@"NSError: %@", error.debugDescription);
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserInformationFetchFailedNotificationName
                                                          object:nil];
    }];
    
  } errorBlock:^(NSError *error) {
    NSLog(@"NSError: %@", error.debugDescription);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInformationFetchFailedNotificationName
                                                        object:nil];
  }];
}

- (void)fetchUserTimelineWithSinceID:(NSString *)sinceID maxID:(NSString *)maxID count:(NSUInteger)count
{
  [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
    
    [self.twitter getUserTimelineWithScreenName:kScreenName sinceID:sinceID maxID:maxID count:count
                                   successBlock:^(NSArray *statuses) {
                          
      self.numberOfNewTweets = statuses.count;
                                    
      for (NSDictionary *tweetDictionary in statuses) {
        [self.tweets addObject:[[Tweet alloc] initWithJSON:tweetDictionary]];
      }
                                     
      NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"objectId"
                                                                      ascending:NO];
      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
      [self.tweets sortUsingDescriptors:sortDescriptors];
                   
      Tweet *firstTweet = (Tweet *)[self.tweets firstObject];
      Tweet *lastTweet = (Tweet *)[self.tweets lastObject];
                                     
      self.sinceID = firstTweet.objectIdString;
      self.maxID = [NSString stringWithFormat: @"%ld", lastTweet.objectId - 1];
                                     
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserTimelineFetchSucceedNotificationName
                                                          object:nil];
                                     
    } errorBlock:^(NSError *error) {
      NSLog(@"NSError: %@", error.debugDescription);
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserTimelineFetchFailedNotificationName
                                                          object:nil];
    }];
     
  } errorBlock:^(NSError *error) {
    NSLog(@"NSError: %@", error.debugDescription);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserTimelineFetchFailedNotificationName
                                                        object:nil];
  }];
}

@end
