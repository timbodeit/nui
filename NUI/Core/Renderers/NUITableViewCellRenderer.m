//
//  NUITableViewCellRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITableViewCellRenderer.h"

@implementation NUITableViewCellRenderer

+ (void)render:(UITableViewCell*)cell withClass:(NSString*)className
{
    [self renderSizeDependentProperties:cell];
    
    // Set the labels' background colors to clearColor by default, so they don't show a white
    // background on top of the cell background color
    if (cell.textLabel != nil) {
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        // Set Font
        [NUIRenderer renderLabel:cell.textLabel withClass:className];
    }
    
    if (cell.detailTextLabel != nil) {
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        // Set font
        [NUIRenderer renderLabel:cell.detailTextLabel withClass:className withSuffix:@"Detail"];
    }

    if ([NUISettings hasProperty:@"tint-color" withClass:className]) {
        cell.tintColor = [NUISettings getColor:@"tint-color" withClass:className];
    }

    if ([NUISettings hasProperty:@"background-color" withClass:className]) {
        cell.backgroundColor = [NUISettings getColor:@"background-color" withClass:className];
    }

    if ([NUISettings hasProperty:@"background-color-selected" withClass:className]) {
        UIImage *colorImage = [NUISettings getImageFromColor:@"background-color-selected" withClass:className];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:colorImage];
    }
    
}

+ (void)sizeDidChange:(UITableViewCell*)cell
{
    [self renderSizeDependentProperties:cell];
}

+ (void)renderSizeDependentProperties:(UITableViewCell*)cell
{
  [self renderSelectionDependentProperties:cell selected:cell.selected];
}

+ (void)renderSelectionDependentProperties:(UITableViewCell*)cell selected:(BOOL)selected
{
  NSString *className = cell.nuiClass;

  if(selected) {
    if ([NUISettings hasProperty:@"checkmark-accessory-on-selection" withClass:className]) {
            BOOL showCheckmark = [NUISettings getBoolean:@"checkmark-accessory-on-selection" withClass:className];
            if(showCheckmark) {
              cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
    }

  } else {
    if ([NUISettings hasProperty:@"checkmark-accessory-on-selection" withClass:className]) {
            BOOL showCheckmark = [NUISettings getBoolean:@"checkmark-accessory-on-selection" withClass:className];
            if(showCheckmark) {
              cell.accessoryType = UITableViewCellAccessoryNone;
            }
    }
  }
}

@end
