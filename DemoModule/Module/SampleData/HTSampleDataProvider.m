#import "HTSampleDataProvider.h"
#import "HTPost.h"

@implementation HTSampleDataProvider

+ (NSArray<HTPost *> *)samplePosts {
    NSArray<NSDictionary *> *data = @[
        @{@"id": @(1), @"userId": @(1), @"title": @"Getting Started with UIKit", @"body": @"UIKit provides the core framework for building iOS user interfaces. This post covers the fundamentals of view controllers, views, and Auto Layout constraints."},
        @{@"id": @(2), @"userId": @(1), @"title": @"NSURLSession Best Practices", @"body": @"Learn how to make efficient network requests using NSURLSession, handle errors gracefully, and parse JSON responses in Objective-C."},
        @{@"id": @(3), @"userId": @(1), @"title": @"Table View Performance Tips", @"body": @"Optimize your UITableView performance with cell reuse, prefetching, and efficient layout calculations for smooth scrolling."},
        @{@"id": @(4), @"userId": @(2), @"title": @"Auto Layout in Code", @"body": @"Build complex layouts programmatically using NSLayoutConstraint and layout anchors. No storyboards required."},
        @{@"id": @(5), @"userId": @(2), @"title": @"Delegate Pattern in Objective-C", @"body": @"Understanding the delegate pattern, one of the most important design patterns in iOS development for component communication."}
    ];
    return [HTPost postsWithArray:data];
}

@end
