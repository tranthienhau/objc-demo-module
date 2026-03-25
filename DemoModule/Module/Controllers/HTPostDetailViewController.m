#import "HTPostDetailViewController.h"
#import "HTPostFormViewController.h"
#import "HTPost.h"
#import "HTDemoModuleDelegate.h"

@interface HTPostDetailViewController ()

@property (nonatomic, strong) HTPost *post;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIView *metadataCard;
@property (nonatomic, strong) UILabel *postIDLabel;
@property (nonatomic, strong) UILabel *userIDLabel;

@end

@implementation HTPostDetailViewController

- (instancetype)initWithPost:(HTPost *)post {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _post = post;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupConstraints];
    [self configureWithPost:self.post];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

#pragma mark - Setup

- (void)setupViews {
    self.title = @"Detail";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                               target:self
                                                                               action:@selector(editButtonTapped)];
    self.navigationItem.rightBarButtonItem = editButton;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];

    _contentContainer = [[UIView alloc] init];
    _contentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_contentContainer];

    // Title card
    UIView *titleCard = [self createCardView];
    [_contentContainer addSubview:titleCard];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
    _titleLabel.textColor = [UIColor labelColor];
    _titleLabel.numberOfLines = 0;
    [titleCard addSubview:_titleLabel];

    _bodyLabel = [[UILabel alloc] init];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    _bodyLabel.textColor = [UIColor secondaryLabelColor];
    _bodyLabel.numberOfLines = 0;
    _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [titleCard addSubview:_bodyLabel];

    // Metadata card
    _metadataCard = [self createCardView];
    [_contentContainer addSubview:_metadataCard];

    UILabel *metaHeader = [[UILabel alloc] init];
    metaHeader.translatesAutoresizingMaskIntoConstraints = NO;
    metaHeader.text = @"Metadata";
    metaHeader.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    metaHeader.textColor = [UIColor tertiaryLabelColor];
    [_metadataCard addSubview:metaHeader];

    _postIDLabel = [[UILabel alloc] init];
    _postIDLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _postIDLabel.font = [UIFont monospacedSystemFontOfSize:14.0 weight:UIFontWeightRegular];
    _postIDLabel.textColor = [UIColor labelColor];
    [_metadataCard addSubview:_postIDLabel];

    _userIDLabel = [[UILabel alloc] init];
    _userIDLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _userIDLabel.font = [UIFont monospacedSystemFontOfSize:14.0 weight:UIFontWeightRegular];
    _userIDLabel.textColor = [UIColor labelColor];
    [_metadataCard addSubview:_userIDLabel];

    // Store cards for constraints
    titleCard.tag = 100;
    _metadataCard.tag = 101;
    metaHeader.tag = 200;

    [self setupCardConstraints:titleCard metadataCard:_metadataCard metaHeader:metaHeader];
}

- (UIView *)createCardView {
    UIView *card = [[UIView alloc] init];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = [UIColor systemBackgroundColor];
    card.layer.cornerRadius = 12.0;
    card.layer.shadowColor = [UIColor blackColor].CGColor;
    card.layer.shadowOpacity = 0.08;
    card.layer.shadowOffset = CGSizeMake(0, 2);
    card.layer.shadowRadius = 8.0;
    return card;
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.contentContainer.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentContainer.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentContainer.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentContainer.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentContainer.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];
}

- (void)setupCardConstraints:(UIView *)titleCard metadataCard:(UIView *)metadataCard metaHeader:(UILabel *)metaHeader {
    [NSLayoutConstraint activateConstraints:@[
        // Title card
        [titleCard.topAnchor constraintEqualToAnchor:self.contentContainer.topAnchor constant:16],
        [titleCard.leadingAnchor constraintEqualToAnchor:self.contentContainer.leadingAnchor constant:16],
        [titleCard.trailingAnchor constraintEqualToAnchor:self.contentContainer.trailingAnchor constant:-16],

        [self.titleLabel.topAnchor constraintEqualToAnchor:titleCard.topAnchor constant:20],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:titleCard.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:titleCard.trailingAnchor constant:-20],

        [self.bodyLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12],
        [self.bodyLabel.leadingAnchor constraintEqualToAnchor:titleCard.leadingAnchor constant:20],
        [self.bodyLabel.trailingAnchor constraintEqualToAnchor:titleCard.trailingAnchor constant:-20],
        [self.bodyLabel.bottomAnchor constraintEqualToAnchor:titleCard.bottomAnchor constant:-20],

        // Metadata card
        [metadataCard.topAnchor constraintEqualToAnchor:titleCard.bottomAnchor constant:16],
        [metadataCard.leadingAnchor constraintEqualToAnchor:self.contentContainer.leadingAnchor constant:16],
        [metadataCard.trailingAnchor constraintEqualToAnchor:self.contentContainer.trailingAnchor constant:-16],
        [metadataCard.bottomAnchor constraintEqualToAnchor:self.contentContainer.bottomAnchor constant:-16],

        [metaHeader.topAnchor constraintEqualToAnchor:metadataCard.topAnchor constant:16],
        [metaHeader.leadingAnchor constraintEqualToAnchor:metadataCard.leadingAnchor constant:20],

        [self.postIDLabel.topAnchor constraintEqualToAnchor:metaHeader.bottomAnchor constant:10],
        [self.postIDLabel.leadingAnchor constraintEqualToAnchor:metadataCard.leadingAnchor constant:20],

        [self.userIDLabel.topAnchor constraintEqualToAnchor:self.postIDLabel.bottomAnchor constant:6],
        [self.userIDLabel.leadingAnchor constraintEqualToAnchor:metadataCard.leadingAnchor constant:20],
        [self.userIDLabel.bottomAnchor constraintEqualToAnchor:metadataCard.bottomAnchor constant:-16]
    ]];
}

#pragma mark - Configuration

- (void)configureWithPost:(HTPost *)post {
    self.titleLabel.text = [post.title capitalizedString];
    self.bodyLabel.text = post.body;
    self.postIDLabel.text = [NSString stringWithFormat:@"Post ID: %ld", (long)post.postID];
    self.userIDLabel.text = [NSString stringWithFormat:@"User ID: %ld", (long)post.userID];
}

#pragma mark - Actions

- (void)editButtonTapped {
    HTPostFormViewController *formVC = [[HTPostFormViewController alloc] initWithPost:self.post];
    formVC.delegate = self.delegate;
    __weak typeof(self) weakSelf = self;
    formVC.onPostCreated = ^(HTPost *updatedPost) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.post = updatedPost;
        [strongSelf configureWithPost:updatedPost];
        if (strongSelf.onPostUpdated) {
            strongSelf.onPostUpdated(updatedPost);
        }
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:formVC];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
