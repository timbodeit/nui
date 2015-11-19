//
//  FlushingTestCase.m
//  NUIDemo
//
//  Created by Tim Bodeit on 19/11/15.
//  Copyright © 2015 Tom Benner. All rights reserved.
//

#import "FlushingTestCase.h"

extern void __gcov_flush();

@implementation FlushingTestCase

+(void)tearDown {
  if (&__gcov_flush != nil) {
    __gcov_flush();
  }
  [super tearDown];
}

@end
