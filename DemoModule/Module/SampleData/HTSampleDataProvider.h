#import <Foundation/Foundation.h>

@class HTPost;

NS_ASSUME_NONNULL_BEGIN

@interface HTSampleDataProvider : NSObject

+ (NSArray<HTPost *> *)samplePosts;

@end

NS_ASSUME_NONNULL_END
