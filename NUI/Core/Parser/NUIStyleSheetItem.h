//
//  NUIStyleSheetItem.h
//  NUI
//
//  Created by Tony Mann on 1/14/14.
//  Copyright (c) 2014 Tom Benner. All rights reserved.
//

@import NUIParse;

@class NUIRuleSet, NUIDefinition, NUIMediaBlock;

@interface NUIStyleSheetItem : NSObject<NUIPParseResult>

@property (strong) NSArray *ruleSets;
@property (strong) NSArray *definitions;

@end
