#import <UIKit/UIKit.h>

@class HTPost;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const HTPostCellIdentifier;

@interface HTPostCell : UITableViewCell

- (void)configureWithPost:(HTPost *)post;

@end

NS_ASSUME_NONNULL_END
