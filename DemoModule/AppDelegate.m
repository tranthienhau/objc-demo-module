#import "AppDelegate.h"
#import "HTDemoModule.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    UIViewController *rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor systemBackgroundColor];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

    // Present the demo module from the host app
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HTDemoModule presentFromViewController:rootVC delegate:self];
    });

    return YES;
}

#pragma mark - HTDemoModuleDelegate

- (void)demoModuleDidFinish {
    NSLog(@"[HostApp] Demo module finished");
}

- (void)demoModuleDidCreatePost:(HTPost *)post {
    NSLog(@"[HostApp] Post created: %@", post);
}

- (void)demoModuleDidUpdatePost:(HTPost *)post {
    NSLog(@"[HostApp] Post updated: %@", post);
}

@end
