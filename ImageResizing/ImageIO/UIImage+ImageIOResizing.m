//
//  UIImage+ImageIOResizing.m
//  ImageResizing
//
//  Created by Hristo Hristov on 7/25/13.
//  Copyright (c) 2013 Hristo Hristov. All rights reserved.
//

#import "UIImage+ImageIOResizing.h"

@implementation UIImage(ImageIOResizing)


- (UIImage *)ior_resizeToSize:(CGSize)size {
  NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
  NSUInteger imageSide = size.width > size.height ? size.width : size.height;
  
  CGImageRef resizedImageRef = MyCreateThumbnailImageFromData(imageData, imageSide);
  UIImage *resizedImage = [UIImage imageWithCGImage:resizedImageRef];
  CGImageRelease(resizedImageRef);
  
  return resizedImage;
  
}

+ (UIImage *)imageData:(NSData *)imageData resizeToSize:(CGSize)size {
  NSUInteger imageSide = size.width > size.height ? size.width : size.height;
  
  CGImageRef resizedImageRef = MyCreateThumbnailImageFromData(imageData, imageSide);
  UIImage *resizedImage = [UIImage imageWithCGImage:resizedImageRef];
  CGImageRelease(resizedImageRef);
  
  return resizedImage;
}

//
// From the ImageIO reference guide creates a thumb image
//
CGImageRef MyCreateThumbnailImageFromData (NSData* data, int imageSize) {
  CGImageRef        myThumbnailImage = NULL;
  CGImageSourceRef  myImageSource;
  CFDictionaryRef   myOptions = NULL;
  CFStringRef       myKeys[3];
  CFTypeRef         myValues[3];
  CFNumberRef       thumbnailSize;
  
  // Create an image source from NSData; no options.
  myImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data,
                                              NULL);
  // Make sure the image source exists before continuing.
  if (myImageSource == NULL){
    fprintf(stderr, "Image source is NULL.");
    return  NULL;
  }
  
  // Package the integer as a  CFNumber object. Using CFTypes allows you
  // to more easily create the options dictionary later.
  thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
  
  // Set up the thumbnail options.
  myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
  myValues[0] = (CFTypeRef)kCFBooleanTrue;
  myKeys[1] = kCGImageSourceCreateThumbnailFromImageAlways;
  myValues[1] = (CFTypeRef)kCFBooleanTrue;
  myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
  myValues[2] = (CFTypeRef)thumbnailSize;
  
  myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                 (const void **) myValues, 3,
                                 &kCFTypeDictionaryKeyCallBacks,
                                 &kCFTypeDictionaryValueCallBacks);
  
  // Create the thumbnail image using the specified options.
  myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                         0,
                                                         myOptions);
  
  //  NSLog(@"num images in source = %zu",CGImageSourceGetCount(myImageSource));
  
  // Release the options dictionary and the image source
  // when you no longer need them.
  CFRelease(thumbnailSize);
  CFRelease(myOptions);
  CFRelease(myImageSource);
  
  // Make sure the thumbnail image exists before continuing.
  if (myThumbnailImage == NULL){
    fprintf(stderr, "Thumbnail image not created from image source.");
    return NULL;
  }
  
  return myThumbnailImage;
}

@end
