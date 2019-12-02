//
//  AppDelegate.m
//  ADCDN_Test
//
//  Created by 彭双塔 on 2019/11/17.
//  Copyright © 2019 pst. All rights reserved.
//

#import "AppDelegate.h"
#import "ADCDN_ViewController.h"
#import "ADCDN_NavigationController.h"

#import <ADCDN/ADCDN.h>

@interface AppDelegate ()<ADCDN_SplashAdManagerDelegate>
/* 开屏广告对象 */
@property (nonatomic,strong) ADCDN_SplashAdManager *manage;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ADCDN_ViewController *vc = [[ADCDN_ViewController alloc] init];
    ADCDN_NavigationController * nav = [[ADCDN_NavigationController alloc] initWithRootViewController:vc];
    vc.modalPresentationStyle = 0;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // 初始化配置
    [ADCDN_ConfigManager shareManagerWithAppId:KappId];
    
    // 初始化开屏广告
    self.manage = [[ADCDN_SplashAdManager alloc] initWithPlcId:KplcId_Splash];
    self.manage.window = self.window;
    CGRect frame = [UIScreen mainScreen].bounds;
    self.manage.wFrame = frame;
    self.manage.delegate = self;// manager需要strong持有，否则delegate回调无法执行，影响计费
    
    //设置开屏底部自定义LogoView，展示半屏开屏广告
    /*
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 0.25)];
    UIImageView *logo = [[UIImageView alloc]initWithFrame:bottomView.frame];
    CGRect logoFrame = logo.frame;
    logoFrame.size.width = bottomView.frame.size.width * 0.5;
    logoFrame.size.height = bottomView.frame.size.height * 0.5;
    logo.frame = logoFrame;
    logo.image = [UIImage imageNamed:@"LOGO"];
    [bottomView addSubview:logo];
    logo.center = bottomView.center;
    bottomView.backgroundColor = [UIColor whiteColor];
    self.manage.bottomView = bottomView;
    */
    [self.manage loadSplashAd];
    
    return YES;
}




#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ADCDN_Test"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
