//
//  UIImage+ImageIOResizing.h
//  ImageResizing
//
//  Created by Hristo Hristov on 7/25/13.
//  Copyright (c) 2013 Hristo Hristov. All rights reserved.
//

#import <ImageIO/ImageIO.h>

@interface UIImage(ImageIOResizing)

- (UIImage *)ior_resizeToSize:(CGSize)size;
+ (UIImage *)imageData:(NSData *)imageData resizeToSize:(CGSize)size;
@end
