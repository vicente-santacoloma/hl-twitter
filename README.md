HL-Twitter
==========

Displays the user information and feed of [Hargreaves Lansdown](https://twitter.com/hlinvest) Twitter account.

Task
----

Build an iOS app that performs the following three functions:
* Displays the @HLInvest twitter feed and the profile (name, twitter handle, location, etc).
* The app should contain two elements (the feed and the profile), in portrait view the profile should be on top of the feed, which should scroll to show older feeds.
In lanscape view the profile should be to the right of the screen with the feed again scrollable in the left hand side.
* The feed data should update once per minute.

**N.B.:** The application should be laid out using auto layout rather thant the struts/springs model.

Requirements
------------

* iOS SDK 8.0 or later 
* Xcode 6 or later

Development Details
-------------------

* The application uses Auto Layout and Size Classes.
* The application has a basic pagination system in order to the get the oldest tweets. After reaching the bottom of the table view, a cell with an activity indicator view will appear and in that moment, the app will start to fetch the oldest tweets. The application is able to fetch new tweets using the table view refresh mechanism or just after 1 minute of waiting. It is worth mentioning that the application was implemented (for simplicity) to only fetch one page of new tweets. This means that it will only fetch the first k number of new tweets where k is the maximum number of tweets to be requested. For example, if after a while, 200 new tweets are created in the Twitter account and if the maximum number of tweets to be fetched is 100, the app will only fetch the first 100 tweets, being impossible to fetch the other 100.  
* The interaction with Twitter API is done using the pod [STTwitter](https://github.com/nst/STTwitter).
* The source code documentation is done using the [appledoc](http://gentlebytes.com/appledoc/) documentation generator scheme. 
