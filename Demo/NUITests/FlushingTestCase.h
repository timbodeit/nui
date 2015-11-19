//
//  FlushingTestCase.h
//  NUIDemo
//
//  Created by Tim Bodeit on 19/11/15.
//  Copyright © 2015 Tom Benner. All rights reserved.
//

#import <XCTest/XCTest.h>

/**
* Certain versions of iOS require manually calling the __gcov_flush() method for generating
* code coverage. A FlushingTestCase automatically does this when completed.
*/
@interface FlushingTestCase : XCTestCase

@end
