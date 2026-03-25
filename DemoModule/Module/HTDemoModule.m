#import "HTDemoModule.h"
#import "HTPostListViewController.h"
#import "HTDemoModuleDelegate.h"

@implementation HTDemoModule

+ (void)presentFromViewController:(UIViewController *)viewController
                          delegate:(id<HTDemoModuleDelegate>)delegate {
    HTPostListViewController *listVC = [[HTPostListViewController alloc] init];
    listVC.delegate = delegate;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    navController.navigationBar.tintColor = [UIColor systemBlueColor];

    [viewController presentViewController:navController animated:YES completion:nil];
}

@end
