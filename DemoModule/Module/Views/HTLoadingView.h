#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTLoadingView : UIView

@property (nonatomic, copy, nullable) NSString *message;

- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
