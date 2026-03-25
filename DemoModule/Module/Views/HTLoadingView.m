#import "HTLoadingView.h"

@interface HTLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation HTLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.alpha = 0;

    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor systemBackgroundColor];
    _containerView.layer.cornerRadius = 16.0;
    _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _containerView.layer.shadowOpacity = 0.15;
    _containerView.layer.shadowOffset = CGSizeMake(0, 4);
    _containerView.layer.shadowRadius = 12.0;
    [self addSubview:_containerView];

    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    _spinner.color = [UIColor systemBlueColor];
    [_containerView addSubview:_spinner];

    _messageLabel = [[UILabel alloc] init];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    _messageLabel.textColor = [UIColor secondaryLabelColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.text = @"Loading...";
    [_containerView addSubview:_messageLabel];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.containerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.containerView.widthAnchor constraintEqualToConstant:140],
        [self.containerView.heightAnchor constraintEqualToConstant:120],

        [self.spinner.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [self.spinner.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:24],

        [self.messageLabel.topAnchor constraintEqualToAnchor:self.spinner.bottomAnchor constant:12],
        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:8],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-8]
    ]];
}

- (void)setMessage:(NSString *)message {
    _message = [message copy];
    self.messageLabel.text = message ?: @"Loading...";
}

- (void)showInView:(UIView *)view {
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:self];
    [self.spinner startAnimating];

    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        }];
    } else {
        self.alpha = 1.0;
    }
}

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.spinner stopAnimating];
            [self removeFromSuperview];
        }];
    } else {
        [self.spinner stopAnimating];
        [self removeFromSuperview];
    }
}

@end
