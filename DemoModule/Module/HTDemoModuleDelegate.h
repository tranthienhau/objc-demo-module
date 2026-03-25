#import <Foundation/Foundation.h>

@class HTPost;

NS_ASSUME_NONNULL_BEGIN

@protocol HTDemoModuleDelegate <NSObject>

@optional
- (void)demoModuleDidFinish;
- (void)demoModuleDidCreatePost:(HTPost *)post;
- (void)demoModuleDidUpdatePost:(HTPost *)post;

@end

NS_ASSUME_NONNULL_END
