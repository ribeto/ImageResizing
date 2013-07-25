//
//  HLHAppDelegate.m
//  ImageResizing
//
//  Created by Hristo Hristov on 7/25/13.
//  Copyright (c) 2013 Hristo Hristov. All rights reserved.
//

#import "HLHAppDelegate.h"
#import "UIImage+ImageIOResizing.h"
#import "UIImage+Resize.h"

@implementation HLHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  
  
  dispatch_queue_t resizeQueue = dispatch_queue_create("com.ribeto.resizeQueue", DISPATCH_QUEUE_CONCURRENT);
  
  dispatch_async(resizeQueue, ^{ [self testResizing]; });
  return YES;
}


- (uint64_t)resizeImages:(NSArray *)images
                 toSizes:(NSArray *)sizes
              useImageIO:(BOOL)useImageIO
              timesToRun:(NSInteger)timesToRun {
  
  uint64_t timeItTook = dispatch_benchmark(timesToRun, ^{
    @autoreleasepool {
      for( UIImage *image in images ) {
        for( NSValue *sizeValue in sizes ) {
          [image ior_resizeToSize:[sizeValue CGSizeValue]];
        }
      }
    }
  });
  return timeItTook;
}

- (void)testResizing {

  NSLog(@"Starting Test");
  NSArray *images = @[[UIImage imageNamed:@"helixnebula.jpg"],
                      [UIImage imageNamed:@"earth.jpg"]];

  NSArray *sizes = @[[NSValue valueWithCGSize:CGSizeMake(1000, 1000)],
                     [NSValue valueWithCGSize:CGSizeMake(500, 500)],
                     [NSValue valueWithCGSize:CGSizeMake(100, 100)]];
  
  NSInteger timesToRun = 1;
  
  uint64_t imageIoTime = [self resizeImages:images toSizes:sizes useImageIO:YES timesToRun:timesToRun];
  NSLog(@"Resizing using image io : %llu ns", imageIoTime);
  
  uint64_t coreGraphicsTime = [self resizeImages:images toSizes:sizes useImageIO:NO timesToRun:timesToRun];
  NSLog(@"Resizing using core graphics : %llu ns", coreGraphicsTime);
  
  if( coreGraphicsTime < imageIoTime ) {
    NSLog(@"Core graphics is faster by %llu ns", imageIoTime-coreGraphicsTime);
  } else {
    NSLog(@"Image IO is faster by %llu ns", coreGraphicsTime-imageIoTime);
  }
  
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
