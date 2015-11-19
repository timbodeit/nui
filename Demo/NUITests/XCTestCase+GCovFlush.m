//
//  XCTestCase+GCovFlush.m
//  NUIDemo
//
//  Created by Tim Bodeit on 19/11/15.
//  Copyright © 2015 Tom Benner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

extern void __gcov_flush();

@implementation XCTestCase (GCovFlush)

+ (void)load {
  Method original, swizzled;
  
  original = class_getClassMethod(self, @selector(tearDown));
  swizzled = class_getClassMethod(self, @selector(_swizzledTearDown));
  method_exchangeImplementations(original, swizzled);
}

+ (void)_swizzledTearDown {
  if (&__gcov_flush != nil) {
    __gcov_flush();
  }
  [self _swizzledTearDown];
}

@end
