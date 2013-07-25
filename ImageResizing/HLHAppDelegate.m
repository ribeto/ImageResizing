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
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{ [self testResizing]; });
  return YES;
}

- (void)testResizing {

  NSLog(@"Starting Test");
  NSArray *images = @[@"helixnebula.jpg",
                      @"earth.jpg",
                      @"square.jpg"];
  NSArray *sizes = @[[NSValue valueWithCGSize:CGSizeMake(1000, 1000)],
                     [NSValue valueWithCGSize:CGSizeMake(500, 500)],
                     [NSValue valueWithCGSize:CGSizeMake(100, 100)]];
  
  uint64_t n = dispatch_benchmark(1, ^{
    for( NSString *imageName in images ) {
      @autoreleasepool {
        UIImage *image = [UIImage imageNamed:imageName];
        for( NSValue *sizeValue in sizes ) {
          [image ior_resizeToSize:[sizeValue CGSizeValue]];
        }
      }
    }
  });
  NSLog(@"Resizing using image io : %llu ns", n);
  
  uint64_t nn = dispatch_benchmark(1, ^{
    @autoreleasepool {
      for( NSString *imageName in images ) {
        @autoreleasepool {
          UIImage *image = [UIImage imageNamed:imageName];
          for( NSValue *sizeValue in sizes ) {
            [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                        bounds:[sizeValue CGSizeValue]
                          interpolationQuality:kCGInterpolationLow];
          }
        }
      }
    }
  });
  NSLog(@"Resizing using core graphics : %llu ns", nn);
  
  if( nn < n ) {
    NSLog(@"Core graphics is faster by %llu ns", n-nn);
  } else {
    NSLog(@"Image IO is faster by %llu ns", nn-n);
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