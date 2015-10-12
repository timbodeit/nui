//
//  UIImageView+NUI.m
//  Pods
//
//  Created by Daniel Strittmatter on 12/10/15.
//
//

#import "UIImageView+NUI.h"

#import "NUIRenderer.h"

@implementation UIImageView (NUI)

- (void)initNUI {
    if (!self.nuiClass) {
        self.nuiClass = @"Image";
    }
}

- (void)applyNUI
{
    [self initNUI];
    if (![self.nuiClass isEqualToString:kNUIClassNone]) {
        [NUIRenderer renderImage:self withClass:self.nuiClass];
    }
    self.nuiApplied = YES;
}
  
@end
