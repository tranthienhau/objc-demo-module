#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTPost : NSObject

@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

+ (instancetype)postWithDictionary:(NSDictionary *)dictionary;
+ (NSArray<HTPost *> *)postsWithArray:(NSArray<NSDictionary *> *)array;

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
