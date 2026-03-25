#import "HTPostCell.h"
#import "HTPost.h"

NSString * const HTPostCellIdentifier = @"HTPostCell";

@interface HTPostCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIView *cardView;

@end

@implementation HTPostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    _cardView = [[UIView alloc] init];
    _cardView.translatesAutoresizingMaskIntoConstraints = NO;
    _cardView.backgroundColor = [UIColor systemBackgroundColor];
    _cardView.layer.cornerRadius = 12.0;
    _cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    _cardView.layer.shadowOpacity = 0.08;
    _cardView.layer.shadowOffset = CGSizeMake(0, 2);
    _cardView.layer.shadowRadius = 8.0;
    [self.contentView addSubview:_cardView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    _titleLabel.textColor = [UIColor labelColor];
    _titleLabel.numberOfLines = 2;
    [_cardView addSubview:_titleLabel];

    _bodyLabel = [[UILabel alloc] init];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    _bodyLabel.textColor = [UIColor secondaryLabelColor];
    _bodyLabel.numberOfLines = 3;
    [_cardView addSubview:_bodyLabel];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:6],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-6],

        [self.titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:14],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],

        [self.bodyLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.bodyLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        [self.bodyLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-14]
    ]];
}

- (void)configureWithPost:(HTPost *)post {
    self.titleLabel.text = [post.title capitalizedString];
    self.bodyLabel.text = post.body;
}

@end
