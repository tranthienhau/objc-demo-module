#import "HTPost.h"

@implementation HTPost

+ (instancetype)postWithDictionary:(NSDictionary *)dictionary {
    HTPost *post = [[HTPost alloc] init];
    post.postID = [dictionary[@"id"] integerValue];
    post.userID = [dictionary[@"userId"] integerValue];
    post.title = dictionary[@"title"] ?: @"";
    post.body = dictionary[@"body"] ?: @"";
    return post;
}

+ (NSArray<HTPost *> *)postsWithArray:(NSArray<NSDictionary *> *)array {
    NSMutableArray<HTPost *> *posts = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [posts addObject:[HTPost postWithDictionary:dict]];
    }
    return [posts copy];
}

- (NSDictionary *)toDictionary {
    return @{
        @"id": @(self.postID),
        @"userId": @(self.userID),
        @"title": self.title,
        @"body": self.body
    };
}

@end
