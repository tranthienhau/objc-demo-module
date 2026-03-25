#import <UIKit/UIKit.h>

@class HTPost;
@protocol HTDemoModuleDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTPostUpdateBlock)(HTPost *updatedPost);

@interface HTPostDetailViewController : UIViewController

@property (nonatomic, weak, nullable) id<HTDemoModuleDelegate> delegate;
@property (nonatomic, copy, nullable) HTPostUpdateBlock onPostUpdated;

- (instancetype)initWithPost:(HTPost *)post NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
