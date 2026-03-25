#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTAPIResponse : NSObject

@property (nonatomic, readonly, nullable) id data;
@property (nonatomic, readonly, nullable) NSString *errorMessage;
@property (nonatomic, readonly, getter=isSuccess) BOOL success;

+ (instancetype)responseWithData:(id)data;
+ (instancetype)responseWithError:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END
