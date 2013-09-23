//
//  AppDelegate.m
//  dox
//
//  Created by Ray Wenderlich on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define kFILENAME @"mydocument.dox"

#import "AppDelegate.h"
#import "ViewController.h"
#import "ListViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize doc = _doc;
@synthesize query = _query;

- (void)loadData:(NSMetadataQuery *)query {
    
    // 判断是否已经建立文件
    if ([query resultCount] == 1) {
        
        // 获取URL创建Doc
        NSMetadataItem *item = [query resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *doc = [[Note alloc] initWithFileURL:url];
        
        self.doc = doc;
        
        // 异步打开文档
        [self.doc openWithCompletionHandler:^(BOOL success) {
            if (success) {                
                NSLog(@"iCloud document opened");                    
            } else {                
                NSLog(@"failed opening document from iCloud");                
            }
        }];

	} 
    else {
        
        // 获取iCloud在本地的地址
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        // 设定需要存放在icloud中的地址
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:kFILENAME];
        
        Note *doc = [[Note alloc] initWithFileURL:ubiquitousPackage];
        self.doc = doc;
        
        // 创建新文件
        [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {            
            if (success) {
                [doc openWithCompletionHandler:^(BOOL success) {
                    
                    NSLog(@"new document opened from iCloud");
                    
                }];                
            }
        }];
    }

}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    
    _query = nil;
    
	[self loadData:query];
    
}

- (void)loadDocument {
    
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    _query = query;
    
    // 设置查询范围为iCloud中Document下的所有文件
    [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    
    // 设置查询限制条件
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"%K == %@", NSMetadataItemFSNameKey, kFILENAME];
    [query setPredicate:pred];
    
    // 注册回调消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
    
    [query startQuery];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ListViewController * listViewController = [[ListViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document... 
        [self loadDocument];
    } else {
        NSLog(@"No iCloud access");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
