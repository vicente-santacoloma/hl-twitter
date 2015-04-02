//
//  ViewController.m
//  HL-Twitter
//
//  Created by Vicente Santacoloma on 31/03/2015.
//  Copyright (c) 2015 Hargreaves Lansdown. All rights reserved.
//

#import "TwitterProfileViewController.h"

// Models
#import "TwitterClient.h"

// Pods
#import "UIImageView+AFNetworking.h"

#define kLoadingCellTag 123
#define kActivityIndicatorTag 456
#define kCount 50

@interface TwitterProfileViewController ()

@property (strong, nonatomic) TwitterClient *twitterClient;

@property (strong, nonatomic) NSArray *tweets;

// User Information
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *details;

// Set this attribute when loading data.
@property (nonatomic, assign) BOOL isLoading;

// Set this attribute when the app is fetching old tweets
@property (assign, nonatomic) BOOL isFetchingOldTweets;

// Set this attribute to YES when there are more old tweets available to be loaded.
// Otherwise, set to NO.
@property (assign, nonatomic) BOOL hasMoreOldTweets;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TwitterProfileViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.twitterClient = [[TwitterClient alloc] init];
  
  self.isFetchingOldTweets = NO;
  self.isLoading = NO;
  
  self.hasMoreOldTweets = NO;
  
  // Setting refresh control mechanism
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(fetchNewTweets)
           forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
  
  // Fetching user information and new tweets
  [self fetchUserInformation];
  [self fetchOldTweets];
  
  // Setting timer
  self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(fetchNewTweets)
                                              userInfo:nil repeats:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSUInteger numberOfTweets = self.tweets.count;
  
  if (self.hasMoreOldTweets && !self.twitterClient.tweetsLimitExceeded) {
    return numberOfTweets + 1;
  }
  
  return numberOfTweets;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  static NSString *LoadingCellIdentifier = @"LoadingCell";
  
  UITableViewCell *cell = nil;
  
  if (indexPath.row < self.tweets.count) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.textLabel.text = tweet.text;
    
    return cell;
  }
  
  cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
  
  // Start activity indicator animation
  UIActivityIndicatorView *activityIndicator =
    (UIActivityIndicatorView *)[cell viewWithTag:kActivityIndicatorTag];
  [activityIndicator startAnimating];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (cell.tag == kLoadingCellTag) {
    [self fetchOldTweets];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row < self.tweets.count) {
    return 100;
  }
  return 44;
}

#pragma mark - Fetching User Information & User Timeline

/**
 Fetches the information of the Twitter user account.
 */
- (void)fetchUserInformation
{
  [self createUserInformationFetchNotifications];
  
  [self.twitterClient fetchUserInformation];
}

/**
 Fetches the new tweets of the Twitter user account.
 */
- (void)fetchNewTweets
{
  if (!self.isLoading) {
    self.isLoading = YES;
    
    [self createUserTimelineFetchNotifications];
    
    [self.twitterClient fetchUserTimelineWithSinceID:self.twitterClient.sinceID maxID:nil count:kCount];
  }
}

/**
 Fetches the old tweets of the Twitter user account.
 */
- (void)fetchOldTweets
{
  if (!self.isLoading) {
    self.isLoading = YES;
    self.isFetchingOldTweets = YES;
    
    [self createUserTimelineFetchNotifications];
    
    [self.twitterClient fetchUserTimelineWithSinceID:nil maxID:self.twitterClient.maxID count:kCount];
  }
}

#pragma mark - Loading User Information & User Timeline

/**
 Sets all the views related to the information of the Twitter user account with the information
 fetched previously.
 */
- (void)loadUserInformation
{
  [self removeUserInformationFetchNotifications];
  
  TwitterUserAccount *userAccount = self.twitterClient.userAccount;
  
  [self.profileImage setImageWithURL:[NSURL URLWithString:userAccount.profileImageURLHTTPS]
                    placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
  self.name.text = userAccount.name;
  self.screenName.text = [NSString stringWithFormat:@"@%@", userAccount.screenName];
  self.location.text = userAccount.location;
  self.details.text = userAccount.details;
}

/**
 Loads the table view using the new array of tweets.
 */
- (void)loadUserTimeline
{
  [self removeUserTimelineFetchNotifications];
  
  [self.refreshControl endRefreshing];
  
  self.isLoading = NO;

  self.tweets = self.twitterClient.tweets;
  
  if (self.isFetchingOldTweets) {
    self.isFetchingOldTweets = NO;
    if (self.twitterClient.numberOfNewTweets < kCount) {
      self.hasMoreOldTweets = NO;
    } else {
      self.hasMoreOldTweets = YES;
    }
  }
  
  if (self.twitterClient.tweetsLimitExceeded) {
    [self.timer invalidate];
    self.timer = nil;
  }
  
  [self.tableView reloadData];
}

/**
 This method is being called when the user information fetch fails.
 */
- (void)userInformationFetchFailed
{
  
}

/**
 This method is being called when the user timeline fetch fails. It ends the refresh control 
 refreshing.
 */
- (void)userTimelineFetchFailed
{
  [self.refreshControl endRefreshing];
}

#pragma mark - Notifications

/**
 Creates fetch user information notifications.
 */
- (void)createUserInformationFetchNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInformation)
                                               name:kUserInformationFetchSucceedNotificationName
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInformationFetchFailed)
                                               name:kUserInformationFetchFailedNotificationName
                                             object:nil];
}

/**
 Creates fetch user timeline notifications
 */
- (void)createUserTimelineFetchNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserTimeline)
                                               name:kUserTimelineFetchSucceedNotificationName
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTimelineFetchFailed)
                                               name:kUserTimelineFetchFailedNotificationName
                                             object:nil];
}

/**
 Removes fetch user information notifications
 */
- (void)removeUserInformationFetchNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserInformationFetchSucceedNotificationName
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserInformationFetchFailedNotificationName
                                                object:nil];
}

/**
 Removes fetch user timeline notifications.
 */
- (void)removeUserTimelineFetchNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserTimelineFetchSucceedNotificationName
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserTimelineFetchFailedNotificationName
                                                object:nil];
}

/**
 Removes all notification associated with this instance class.
 */
- (void)removeNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
