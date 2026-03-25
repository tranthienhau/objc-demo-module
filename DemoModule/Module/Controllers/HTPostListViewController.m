#import "HTPostListViewController.h"
#import "HTPostDetailViewController.h"
#import "HTPostFormViewController.h"
#import "HTPostCell.h"
#import "HTLoadingView.h"
#import "HTAPIClient.h"
#import "HTAPIResponse.h"
#import "HTPost.h"
#import "HTSampleDataProvider.h"
#import "HTDemoModuleDelegate.h"

@interface HTPostListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) HTLoadingView *loadingView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) NSArray<HTPost *> *posts;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HTPostListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
    [self setupEmptyState];
    [self fetchPosts];
}

#pragma mark - Setup

- (void)setupNavigation {
    self.title = @"Posts";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem = addButton;

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(closeButtonTapped)];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerClass:[HTPostCell class] forCellReuseIdentifier:HTPostCellIdentifier];
    [self.view addSubview:_tableView];

    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    _tableView.refreshControl = _refreshControl;

    [NSLayoutConstraint activateConstraints:@[
        [_tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)setupEmptyState {
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _emptyLabel.text = @"No posts yet.\nTap + to create one.";
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.numberOfLines = 0;
    _emptyLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    _emptyLabel.textColor = [UIColor tertiaryLabelColor];
    _emptyLabel.hidden = YES;
    [self.view addSubview:_emptyLabel];

    [NSLayoutConstraint activateConstraints:@[
        [_emptyLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_emptyLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [_emptyLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:40],
        [_emptyLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-40]
    ]];
}

#pragma mark - Data Fetching

- (void)fetchPosts {
    if (self.isLoading) return;
    self.isLoading = YES;

    if (self.posts.count == 0) {
        self.loadingView = [[HTLoadingView alloc] init];
        [self.loadingView showInView:self.view];
    }

    [[HTAPIClient sharedClient] fetchPostsWithCompletion:^(HTAPIResponse *response) {
        self.isLoading = NO;
        [self.loadingView dismiss];
        [self.refreshControl endRefreshing];

        if (response.isSuccess && [response.data isKindOfClass:[NSArray class]]) {
            self.posts = [HTPost postsWithArray:response.data];
        } else {
            self.posts = [HTSampleDataProvider samplePosts];
        }

        self.emptyLabel.hidden = self.posts.count > 0;
        [self.tableView reloadData];
    }];
}

- (void)handleRefresh {
    [self fetchPosts];
}

#pragma mark - Actions

- (void)addButtonTapped {
    HTPostFormViewController *formVC = [[HTPostFormViewController alloc] init];
    formVC.delegate = self.delegate;
    __weak typeof(self) weakSelf = self;
    formVC.onPostCreated = ^(HTPost *post) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        NSMutableArray *mutablePosts = [strongSelf.posts mutableCopy];
        [mutablePosts insertObject:post atIndex:0];
        strongSelf.posts = [mutablePosts copy];
        strongSelf.emptyLabel.hidden = YES;
        [strongSelf.tableView reloadData];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:formVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)closeButtonTapped {
    if ([self.delegate respondsToSelector:@selector(demoModuleDidFinish)]) {
        [self.delegate demoModuleDidFinish];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTPostCell *cell = [tableView dequeueReusableCellWithIdentifier:HTPostCellIdentifier forIndexPath:indexPath];
    [cell configureWithPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTPost *post = self.posts[indexPath.row];
    HTPostDetailViewController *detailVC = [[HTPostDetailViewController alloc] initWithPost:post];
    detailVC.delegate = self.delegate;
    __weak typeof(self) weakSelf = self;
    detailVC.onPostUpdated = ^(HTPost *updatedPost) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        NSMutableArray *mutablePosts = [strongSelf.posts mutableCopy];
        [mutablePosts replaceObjectAtIndex:indexPath.row withObject:updatedPost];
        strongSelf.posts = [mutablePosts copy];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
