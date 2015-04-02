//
//  TwitterPost.m
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithJSON:(NSDictionary *)JSON
{
  self = [super init];
  if (self) {
    self.objectId = [JSON[@"id"] integerValue];
    self.objectIdString = JSON[@"id_str"];
    self.text = JSON[@"text"];
  }
  return self;
}

@end
