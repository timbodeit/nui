//
//  NUIImageRenderer.m
//  Pods
//
//  Created by Daniel Strittmatter on 12/10/15.
//
//

#import "NUIImageRenderer.h"

#import "NUISettings.h"
#import "NUIViewRenderer.h"

@implementation NUIImageRenderer

+ (void)render:(UIImageView*)imageView withClass:(NSString *)className {
    [NUIViewRenderer render:imageView withClass:className];
  
    if ([NUISettings hasProperty:@"image" withClass:className]) {
      UIImage* image = [NUISettings getImage:@"image" withClass:className];
      if (image) {
        imageView.image = image;
      }
    }
}

@end
