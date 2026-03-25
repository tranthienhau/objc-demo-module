#import "HTPostFormViewController.h"
#import "HTLoadingView.h"
#import "HTAPIClient.h"
#import "HTAPIResponse.h"
#import "HTPost.h"
#import "HTDemoModuleDelegate.h"

@interface HTPostFormViewController ()

@property (nonatomic, strong, nullable) HTPost *existingPost;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *formContainer;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextView *bodyTextView;
@property (nonatomic, strong) UILabel *titleErrorLabel;
@property (nonatomic, strong) UILabel *bodyErrorLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) HTLoadingView *loadingView;

@end

@implementation HTPostFormViewController

- (instancetype)initWithPost:(HTPost *)post {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _existingPost = post;
    }
    return self;
}

- (instancetype)init {
    return [self initWithPost:nil];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupConstraints];
    [self populateIfEditing];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Setup

- (void)setupViews {
    BOOL isEditing = self.existingPost != nil;
    self.title = isEditing ? @"Edit Post" : @"New Post";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(cancelTapped)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];

    _formContainer = [[UIView alloc] init];
    _formContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_formContainer];

    // Title section
    UILabel *titleHeader = [self createHeaderLabel:@"TITLE"];
    [_formContainer addSubview:titleHeader];

    _titleField = [[UITextField alloc] init];
    _titleField.translatesAutoresizingMaskIntoConstraints = NO;
    _titleField.borderStyle = UITextBorderStyleNone;
    _titleField.font = [UIFont systemFontOfSize:16.0];
    _titleField.placeholder = @"Enter post title";
    _titleField.backgroundColor = [UIColor systemBackgroundColor];
    _titleField.layer.cornerRadius = 10.0;
    _titleField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
    _titleField.leftViewMode = UITextFieldViewModeAlways;
    _titleField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
    _titleField.rightViewMode = UITextFieldViewModeAlways;
    [_formContainer addSubview:_titleField];

    _titleErrorLabel = [self createErrorLabel];
    [_formContainer addSubview:_titleErrorLabel];

    // Body section
    UILabel *bodyHeader = [self createHeaderLabel:@"BODY"];
    [_formContainer addSubview:bodyHeader];

    _bodyTextView = [[UITextView alloc] init];
    _bodyTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyTextView.font = [UIFont systemFontOfSize:16.0];
    _bodyTextView.backgroundColor = [UIColor systemBackgroundColor];
    _bodyTextView.layer.cornerRadius = 10.0;
    _bodyTextView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
    [_formContainer addSubview:_bodyTextView];

    _bodyErrorLabel = [self createErrorLabel];
    [_formContainer addSubview:_bodyErrorLabel];

    // Submit button
    _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_submitButton setTitle:isEditing ? @"Update Post" : @"Create Post" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    _submitButton.backgroundColor = [UIColor systemBlueColor];
    _submitButton.layer.cornerRadius = 12.0;
    [_submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    [_formContainer addSubview:_submitButton];

    // Store tags for constraints
    titleHeader.tag = 300;
    bodyHeader.tag = 301;

    [self setupFormConstraints:titleHeader bodyHeader:bodyHeader];
}

- (UILabel *)createHeaderLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    label.textColor = [UIColor secondaryLabelColor];
    return label;
}

- (UILabel *)createErrorLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    label.textColor = [UIColor systemRedColor];
    label.hidden = YES;
    return label;
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.formContainer.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.formContainer.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.formContainer.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.formContainer.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.formContainer.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];
}

- (void)setupFormConstraints:(UILabel *)titleHeader bodyHeader:(UILabel *)bodyHeader {
    [NSLayoutConstraint activateConstraints:@[
        [titleHeader.topAnchor constraintEqualToAnchor:self.formContainer.topAnchor constant:24],
        [titleHeader.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:20],

        [self.titleField.topAnchor constraintEqualToAnchor:titleHeader.bottomAnchor constant:8],
        [self.titleField.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:16],
        [self.titleField.trailingAnchor constraintEqualToAnchor:self.formContainer.trailingAnchor constant:-16],
        [self.titleField.heightAnchor constraintEqualToConstant:48],

        [self.titleErrorLabel.topAnchor constraintEqualToAnchor:self.titleField.bottomAnchor constant:4],
        [self.titleErrorLabel.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:20],

        [bodyHeader.topAnchor constraintEqualToAnchor:self.titleErrorLabel.bottomAnchor constant:20],
        [bodyHeader.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:20],

        [self.bodyTextView.topAnchor constraintEqualToAnchor:bodyHeader.bottomAnchor constant:8],
        [self.bodyTextView.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:16],
        [self.bodyTextView.trailingAnchor constraintEqualToAnchor:self.formContainer.trailingAnchor constant:-16],
        [self.bodyTextView.heightAnchor constraintEqualToConstant:160],

        [self.bodyErrorLabel.topAnchor constraintEqualToAnchor:self.bodyTextView.bottomAnchor constant:4],
        [self.bodyErrorLabel.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:20],

        [self.submitButton.topAnchor constraintEqualToAnchor:self.bodyErrorLabel.bottomAnchor constant:32],
        [self.submitButton.leadingAnchor constraintEqualToAnchor:self.formContainer.leadingAnchor constant:16],
        [self.submitButton.trailingAnchor constraintEqualToAnchor:self.formContainer.trailingAnchor constant:-16],
        [self.submitButton.heightAnchor constraintEqualToConstant:52],
        [self.submitButton.bottomAnchor constraintEqualToAnchor:self.formContainer.bottomAnchor constant:-32]
    ]];
}

- (void)populateIfEditing {
    if (self.existingPost) {
        self.titleField.text = self.existingPost.title;
        self.bodyTextView.text = self.existingPost.body;
    }
}

#pragma mark - Validation

- (BOOL)validateForm {
    BOOL valid = YES;

    NSString *title = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (title.length == 0) {
        self.titleErrorLabel.text = @"Title is required";
        self.titleErrorLabel.hidden = NO;
        valid = NO;
    } else {
        self.titleErrorLabel.hidden = YES;
    }

    NSString *body = [self.bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (body.length == 0) {
        self.bodyErrorLabel.text = @"Body is required";
        self.bodyErrorLabel.hidden = NO;
        valid = NO;
    } else {
        self.bodyErrorLabel.hidden = YES;
    }

    return valid;
}

#pragma mark - Actions

- (void)cancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitTapped {
    if (![self validateForm]) return;

    NSString *title = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *body = [self.bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    self.submitButton.enabled = NO;
    self.loadingView = [[HTLoadingView alloc] init];
    self.loadingView.message = self.existingPost ? @"Updating..." : @"Creating...";
    [self.loadingView showInView:self.view];

    if (self.existingPost) {
        [[HTAPIClient sharedClient] updatePostWithID:self.existingPost.postID title:title body:body completion:^(HTAPIResponse *response) {
            [self handleSubmitResponse:response title:title body:body];
        }];
    } else {
        [[HTAPIClient sharedClient] createPostWithTitle:title body:body completion:^(HTAPIResponse *response) {
            [self handleSubmitResponse:response title:title body:body];
        }];
    }
}

- (void)handleSubmitResponse:(HTAPIResponse *)response title:(NSString *)title body:(NSString *)body {
    [self.loadingView dismiss];
    self.submitButton.enabled = YES;

    HTPost *post;
    if (response.isSuccess && [response.data isKindOfClass:[NSDictionary class]]) {
        post = [HTPost postWithDictionary:response.data];
    } else {
        // Build post from input on failure (API is a mock anyway)
        post = [[HTPost alloc] init];
        post.postID = self.existingPost ? self.existingPost.postID : arc4random_uniform(1000) + 101;
        post.userID = 1;
        post.title = title;
        post.body = body;
    }

    if (self.onPostCreated) {
        self.onPostCreated(post);
    }

    if (self.existingPost) {
        if ([self.delegate respondsToSelector:@selector(demoModuleDidUpdatePost:)]) {
            [self.delegate demoModuleDidUpdatePost:post];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(demoModuleDidCreatePost:)]) {
            [self.delegate demoModuleDidCreatePost:post];
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
