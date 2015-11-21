//
//  NUINavigationItemRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUINavigationItemRenderer.h"

@implementation NUINavigationItemRenderer

+ (void)render:(UINavigationItem*)item withClass:(NSString*)className
{
    if (item.backBarButtonItem != nil) {
      [NUIRenderer renderView:item.backBarButtonItem withClass: item.backBarButtonItem.nuiClass];
    }
    if (item.leftBarButtonItem != nil) {
        [NUIRenderer renderView:item.leftBarButtonItem withClass: item.leftBarButtonItem.nuiClass];
    }
    if (item.rightBarButtonItem != nil) {
        [NUIRenderer renderView:item.rightBarButtonItem withClass: item.rightBarButtonItem.nuiClass];
    }
}

@end
