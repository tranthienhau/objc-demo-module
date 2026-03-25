#import <UIKit/UIKit.h>

@protocol HTDemoModuleDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface HTPostListViewController : UIViewController

@property (nonatomic, weak, nullable) id<HTDemoModuleDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
