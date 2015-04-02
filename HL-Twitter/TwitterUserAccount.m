//
//  TwitterUserAccount.m
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import "TwitterUserAccount.h"

@implementation TwitterUserAccount

- (id)initWithJSON:(NSDictionary *)JSON
{
  self = [super init];
  if (self) {
    self.objectId = [JSON[@"id"] integerValue];
    self.objectIdString = JSON[@"id_str"];
    self.screenName = JSON[@"screen_name"];
    self.name = JSON[@"name"];
    self.location = JSON[@"location"];
    self.details = JSON[@"description"];
    self.profileImageURLHTTPS = JSON[@"profile_image_url_https"];
  }
  return self;
}

@end
