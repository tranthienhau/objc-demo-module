#import "HTAPIResponse.h"

@interface HTAPIResponse ()

@property (nonatomic, readwrite, nullable) id data;
@property (nonatomic, readwrite, nullable) NSString *errorMessage;

@end

@implementation HTAPIResponse

+ (instancetype)responseWithData:(id)data {
    HTAPIResponse *response = [[HTAPIResponse alloc] init];
    response.data = data;
    return response;
}

+ (instancetype)responseWithError:(NSString *)errorMessage {
    HTAPIResponse *response = [[HTAPIResponse alloc] init];
    response.errorMessage = errorMessage;
    return response;
}

- (BOOL)isSuccess {
    return self.errorMessage == nil && self.data != nil;
}

@end
