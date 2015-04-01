//
//  ViewController.m
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import "ViewController.h"

// Models
#import "TwitterAPI.h"

// Pods
#import "UIImageView+AFNetworking.h"

#define kLoadingCellTag 123
#define kCount 10

@interface ViewController ()

@property (strong, nonatomic) TwitterAPI *twitterAPI;

@property (strong, nonatomic) NSString *maxID;
@property (strong, nonatomic) NSString *sinceID;

@property (strong, nonatomic) NSString *highestTweetID;
@property (strong, nonatomic) NSString *lowestTweetID;

@property (assign, nonatomic) BOOL isFirstLoading;
@property (assign, nonatomic) BOOL isFetchingOldTweets;
@property (assign, nonatomic) BOOL hasMoreNewTweets;
@property (assign, nonatomic) BOOL hasMoreOldTweets;

/**
 *  Set this flag when loading data.
 */
@property (nonatomic, assign) BOOL isLoading;

@property (strong, nonatomic) NSMutableArray *twitterFeed;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *details;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

/**
 *  Set this flag if more data can be loaded.
 */
@property (assign, nonatomic) BOOL hasNextPage;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.isFirstLoading = YES;
  self.isFetchingOldTweets = NO;
  self.isLoading = NO;
  
  self.hasMoreNewTweets = NO;
  self.hasMoreOldTweets = NO;
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(fetchNewTweets)
           forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
 
  self.twitterAPI = [[TwitterAPI alloc] init];
  
  self.maxID = nil;
  self.sinceID = nil;
  
  [self fetchUserAcoount];
  [self fetchNewTweets];
  
  [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(fetchNewTweets)
                                 userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSUInteger numberOfTweets = self.twitterFeed.count;
  
  if (self.hasMoreOldTweets) {
    return numberOfTweets + 1;
  }
  
  return numberOfTweets;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  static NSString *LoaderCellIdentifier = @"LoaderCell";
  
  UITableViewCell *cell = nil;
  
  if (indexPath.row < self.twitterFeed.count) {
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Tweet *tweet = self.twitterFeed[indexPath.row];
    
    cell.textLabel.text = tweet.text;
    
    return cell;
  }
  
  cell = [tableView dequeueReusableCellWithIdentifier:LoaderCellIdentifier forIndexPath:indexPath];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (cell.tag == kLoadingCellTag) {
    [self fetchOldTweets];
  }
}

- (void)fetchUserAcoount
{
  [self createFetchUserAccountSucceedNotification];
  [self.twitterAPI fetchUserAccount];
}

- (void)fetchNewTweets
{
  if (!self.isLoading) {
    self.isLoading = YES;
    [self createFetchTweetsSucceedNotification];
    [self.twitterAPI fetchTweetsWithSinceID:self.sinceID maxID:nil count:kCount];
  }
}

- (void)fetchOldTweets
{
  if (!self.isLoading) {
    self.isLoading = YES;
    self.isFetchingOldTweets = YES;
    
    [self createFetchTweetsSucceedNotification];
    [self.twitterAPI fetchTweetsWithSinceID:nil maxID:self.maxID count:kCount];
  }
}

- (void)loadUserInformation
{
  [self removeFetchUserAccountSucceedNotification];
  
  TwitterUserAccount *userAccount = self.twitterAPI.userAccount;
  
  [self.profileImage setImageWithURL:[NSURL URLWithString:userAccount.profileImageURLHTTPS]
                    placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
  self.screenName.text = userAccount.screenName;
  self.name.text = userAccount.name;
  self.location.text = userAccount.location;
  self.details.text = userAccount.details;
}

- (void)loadTweets
{
  [self.refreshControl endRefreshing];
  self.isLoading = NO;
  [self removeFetchTweetsSucceedNotification];
  //self.twitterFeed = [NSMutableArray arrayWithArray:[self.twitterAPI.tweets allObjects]];
  self.twitterFeed = self.twitterAPI.tweets;
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"objectId"
                                                                 ascending:NO];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  [self.twitterAPI.tweets sortUsingDescriptors:sortDescriptors];
  self.twitterFeed = self.twitterAPI.tweets;
  
  Tweet *firstTweet = (Tweet *)[self.twitterFeed firstObject];
  Tweet *lastTweet = (Tweet *)[self.twitterFeed lastObject];
  
  self.sinceID = firstTweet.objectIdString;
  self.maxID = [NSString stringWithFormat: @"%ld", lastTweet.objectId - 1];
  
  if (self.isFirstLoading) {
    self.isFirstLoading = NO;
    if (self.twitterAPI.numberOfNewTweets == kCount) {
      self.hasMoreOldTweets = YES;
    }
  }
  
  if (self.isFetchingOldTweets) {
    self.isFetchingOldTweets = NO;
    if (self.twitterAPI.numberOfNewTweets < kCount) {
      self.hasMoreOldTweets = NO;
    } else {
      self.hasMoreOldTweets = YES;
    }
  }
  
  [self.tableView reloadData];
}

- (void)createFetchUserAccountSucceedNotification
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInformation)
                                               name:@"TwitterUserAccountFinishedFetching"
                                             object:nil];
}

- (void)removeFetchUserAccountSucceedNotification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:@"TwitterUserAccountFinishedFetching"
                                                object:nil];
}

- (void)createFetchTweetsSucceedNotification
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTweets)
                                               name:@"TweetsFinishedFetching"
                                             object:nil];
}


- (void)removeFetchTweetsSucceedNotification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:@"TweetsFinishedFetching"
                                                object:nil];
}

@end
