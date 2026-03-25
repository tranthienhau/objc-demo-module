#import <Foundation/Foundation.h>

@class HTAPIResponse;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTAPICompletionBlock)(HTAPIResponse *response);

@interface HTAPIClient : NSObject

@property (class, readonly, strong) HTAPIClient *sharedClient;

- (void)fetchPostsWithCompletion:(HTAPICompletionBlock)completion;
- (void)fetchPostWithID:(NSInteger)postID completion:(HTAPICompletionBlock)completion;
- (void)createPostWithTitle:(NSString *)title body:(NSString *)body completion:(HTAPICompletionBlock)completion;
- (void)updatePostWithID:(NSInteger)postID title:(NSString *)title body:(NSString *)body completion:(HTAPICompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
