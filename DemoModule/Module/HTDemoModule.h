#import <UIKit/UIKit.h>

@protocol HTDemoModuleDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface HTDemoModule : NSObject

+ (void)presentFromViewController:(UIViewController *)viewController
                          delegate:(nullable id<HTDemoModuleDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
