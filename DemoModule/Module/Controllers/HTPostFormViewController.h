#import <UIKit/UIKit.h>

@class HTPost;
@protocol HTDemoModuleDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HTPostCreatedBlock)(HTPost *post);

@interface HTPostFormViewController : UIViewController

@property (nonatomic, weak, nullable) id<HTDemoModuleDelegate> delegate;
@property (nonatomic, copy, nullable) HTPostCreatedBlock onPostCreated;

- (instancetype)initWithPost:(nullable HTPost *)post NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
