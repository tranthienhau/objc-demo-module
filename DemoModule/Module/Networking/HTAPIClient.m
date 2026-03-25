#import "HTAPIClient.h"
#import "HTAPIResponse.h"

static NSString * const kBaseURL = @"https://jsonplaceholder.typicode.com";

@interface HTAPIClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HTAPIClient

+ (HTAPIClient *)sharedClient {
    static HTAPIClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[HTAPIClient alloc] init];
    });
    return client;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15.0;
        config.timeoutIntervalForResource = 30.0;
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

#pragma mark - Public Methods

- (void)fetchPostsWithCompletion:(HTAPICompletionBlock)completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/posts", kBaseURL];
    [self performGETRequestWithURL:urlString completion:completion];
}

- (void)fetchPostWithID:(NSInteger)postID completion:(HTAPICompletionBlock)completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/posts/%ld", kBaseURL, (long)postID];
    [self performGETRequestWithURL:urlString completion:completion];
}

- (void)createPostWithTitle:(NSString *)title body:(NSString *)body completion:(HTAPICompletionBlock)completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/posts", kBaseURL];
    NSDictionary *params = @{@"title": title, @"body": body, @"userId": @(1)};
    [self performPOSTRequestWithURL:urlString parameters:params completion:completion];
}

- (void)updatePostWithID:(NSInteger)postID title:(NSString *)title body:(NSString *)body completion:(HTAPICompletionBlock)completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/posts/%ld", kBaseURL, (long)postID];
    NSDictionary *params = @{@"title": title, @"body": body, @"userId": @(1)};
    [self performPUTRequestWithURL:urlString parameters:params completion:completion];
}

#pragma mark - Private Methods

- (void)performGETRequestWithURL:(NSString *)urlString completion:(HTAPICompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:@"Invalid URL"]];
        return;
    }

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:error.localizedDescription]];
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSString *msg = [NSString stringWithFormat:@"Server error: %ld", (long)httpResponse.statusCode];
            [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:msg]];
            return;
        }

        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:@"Failed to parse response"]];
            return;
        }

        [self callCompletion:completion withResponse:[HTAPIResponse responseWithData:json]];
    }];

    [task resume];
}

- (void)performPOSTRequestWithURL:(NSString *)urlString parameters:(NSDictionary *)params completion:(HTAPICompletionBlock)completion {
    [self performRequestWithMethod:@"POST" url:urlString parameters:params completion:completion];
}

- (void)performPUTRequestWithURL:(NSString *)urlString parameters:(NSDictionary *)params completion:(HTAPICompletionBlock)completion {
    [self performRequestWithMethod:@"PUT" url:urlString parameters:params completion:completion];
}

- (void)performRequestWithMethod:(NSString *)method url:(NSString *)urlString parameters:(NSDictionary *)params completion:(HTAPICompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:@"Invalid URL"]];
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

    NSError *jsonError = nil;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
    if (jsonError) {
        [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:@"Failed to encode parameters"]];
        return;
    }

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:error.localizedDescription]];
            return;
        }

        NSError *parseError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError) {
            [self callCompletion:completion withResponse:[HTAPIResponse responseWithError:@"Failed to parse response"]];
            return;
        }

        [self callCompletion:completion withResponse:[HTAPIResponse responseWithData:json]];
    }];

    [task resume];
}

- (void)callCompletion:(HTAPICompletionBlock)completion withResponse:(HTAPIResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(response);
    });
}

@end
