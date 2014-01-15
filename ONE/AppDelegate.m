//
//  AppDelegate.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTableBarController.h"
#import "LoginViewController.h"
#import "MobClick.h"
@implementation AppDelegate
@synthesize window=_window;
@synthesize viewController = _viewController;

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}
- (void)dealloc
{
    [_window release];
    [_viewController release];    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]];
//加载登陆界面LoginViewController
  
//  [MyTableBarController sharedTabBarController].delegate=self;
    [self.window setRootViewController:[MyTableBarController sharedTabBarController]];
    [MobClick startWithAppkey:@"50ee1376527015619400000c"];
    [MobClick checkUpdate];
    [self.window makeKeyAndVisible];
    
    //判断是否是第一次打开app
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    } 
    //向微信注册 wxab1361372f33703b
    [WXApi registerApp:@"wxab1361372f33703b"];
    //注册消息发送机制
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    return YES;
}
//注册消息发送机制后两个必须回调的方法
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"My token is:%@", token);
//上传token给服务器
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat: @"http://matrix.clickharbour.com/pages/tsxx.aspx?adddeviretoken=%@",deviceToken]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"传token的事件url = %@",url);
   ASIHTTPRequest* _upDateRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    [_upDateRequest startAsynchronous];
    [_upDateRequest setFailedBlock:^{
        NSLog(@"传送token信息失败");
        
    }];
    [_upDateRequest setCompletionBlock:^{
        NSLog(@"传送token信息成功");
    }];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
   
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
