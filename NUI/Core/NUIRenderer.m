//
//  NUIRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIRenderer.h"
#import "UIProgressView+NUI.h"

@implementation NUIRenderer

static NUIRenderer *gInstance = nil;

static NSMutableDictionary *_renderersForClasses;

+(NSMutableDictionary*)renderersForClasses
{
  if (!_renderersForClasses) {
    _renderersForClasses =
        @{ (id <NSCopying>)[UIBarButtonItem class]:    [NUIBarButtonItemRenderer class]
         , (id <NSCopying>)[UIButton class]:           [NUIButtonRenderer class]
         , (id <NSCopying>)[UIControl class]:          [NUIControlRenderer class]
         , (id <NSCopying>)[UILabel class]:            [NUILabelRenderer class]
         , (id <NSCopying>)[UINavigationBar class]:    [NUINavigationBarRenderer class]
         , (id <NSCopying>)[UIProgressView class]:     [NUIProgressViewRenderer class]
         , (id <NSCopying>)[UINavigationItem class]:   [NUINavigationItemRenderer class]
         , (id <NSCopying>)[UISearchBar class]:        [NUISearchBarRenderer class]
         , (id <NSCopying>)[UISegmentedControl class]: [NUISegmentedControlRenderer class]
         , (id <NSCopying>)[UISlider class]:           [NUISliderRenderer class]
         , (id <NSCopying>)[UISwitch class]:           [NUISwitchRenderer class]
         , (id <NSCopying>)[UITabBar class]:           [NUITabBarRenderer class]
         , (id <NSCopying>)[UITabBarItem class]:       [NUITabBarItemRenderer class]
         , (id <NSCopying>)[UITableView class]:        [NUITableViewRenderer class]
         , (id <NSCopying>)[UITableViewCell class]:    [NUITableViewCellRenderer class]
         , (id <NSCopying>)[UIToolbar class]:          [NUIToolbarRenderer class]
         , (id <NSCopying>)[UITextField class]:        [NUITextFieldRenderer class]
         , (id <NSCopying>)[UITextView class]:         [NUITextViewRenderer class]
         , (id <NSCopying>)[UIView class]:             [NUIViewRenderer class]
         , (id <NSCopying>)[UIWindow class]:           [NUIWindowRenderer class]
         }.mutableCopy;
  }
  return _renderersForClasses;
}

+(void)setRenderer:(Class)rendererClass forObjectClass:(Class)objectClass
{
  [[self renderersForClasses] setObject:rendererClass
                                 forKey:(id<NSCopying>)objectClass];
}

BOOL classDescendsFromClass(Class classA, Class classB)
{
  while(classA)
  {
    if(classA == classB) return YES;
    classA = class_getSuperclass(classA);
  }
  
  return NO;
}

+ (Class)rendererForClass: (Class)class {
  __block Class returnValue;
  NSDictionary* renderersForClasses = [self renderersForClasses];
  [renderersForClasses enumerateKeysAndObjectsUsingBlock:^(Class _Nonnull key, Class _Nonnull obj, BOOL * _Nonnull stop) {
    if (!classDescendsFromClass(class, key)) {
      // Renderer object class is not a superclass of class
      return;
    }
    for (Class key2 in renderersForClasses) {
      if (classDescendsFromClass(key2, key) &&
          classDescendsFromClass(class, key2) &&
          key2 != key) {
        // There is another object class that is more specific
        return;
      }
    }
    // key is the most specific object class for which a renderer has been specified
    returnValue = obj;
    *stop = YES;
  }];
  return returnValue;
}

+ (void)renderView:(id)view
{
  [self renderView:view withClass:nil];
}

+ (void)renderView:(id)view withClass:(NSString*)className
{
  Class renderer = [self rendererForClass:[view class]];
  [renderer render:view withClass:className];
}

+ (BOOL)needsTextTransformWithClass:(NSString*)className
{
    return [NUILabelRenderer needsTextTransformWithClass:className];
}

+ (NSString *)transformText:(NSString*)text withClass:(NSString*)className
{
    return [NUILabelRenderer transformText:text withClass:className];
}

+ (NSAttributedString *)transformAttributedText:(NSAttributedString*)text withClass:(NSString*)className
{
    return [NUILabelRenderer transformAttributedText:text withClass:className];
}

+ (void)sizeDidChangeForNavigationBar:(UINavigationBar*)bar
{
    [NUINavigationBarRenderer sizeDidChange:bar];
}

+ (void)sizeDidChangeForTabBar:(UITabBar*)bar
{
    [NUITabBarRenderer sizeDidChange:bar];
}

+ (void)sizeDidChangeForTableViewCell:(UITableViewCell*)cell
{
    [NUITableViewCellRenderer sizeDidChange:cell];
}

+ (void)sizeDidChangeForTableView:(UITableView*)tableView
{
    [NUITableViewRenderer sizeDidChange:tableView];
}

+ (void)addOrientationDidChangeObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(orientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

+ (void)removeOrientationDidChangeObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

+ (void)rerender
{
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        UIView *rootView = [[window rootViewController] view];
        [self rerenderView:rootView];
    }
}

+ (void)rerenderView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        [self rerenderView:subview];
    }

    if ([view respondsToSelector:@selector(applyNUI)]){
        [view applyNUI];
    }
    
    if ([view respondsToSelector:@selector(inputAccessoryView)]){
        if ([view isFirstResponder]) {
            UIView *inputAccessoryView = [view inputAccessoryView];
            
            if (inputAccessoryView)
                [self rerenderView:inputAccessoryView];
        }
    }
}

+ (void)setRerenderOnOrientationChange:(BOOL)rerender
{
    NUIRenderer *instance = [self getInstance];

    if (instance.rerenderOnOrientationChange != rerender) {
        instance.rerenderOnOrientationChange = rerender;

        if (rerender) {
            [self addOrientationDidChangeObserver:self];
        } else {
            [self removeOrientationDidChangeObserver:self];
        }
    }
}

+ (NUIRenderer*)getInstance
{
    @synchronized(self) {
        if (gInstance == nil) {
            gInstance = [NUIRenderer new];
            if ([NUISettings autoUpdateIsEnabled]) {
                [NUIFileMonitor watch:[NUISettings autoUpdatePath] withCallback:^(){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stylesheetFileChanged];
                    });
                }];
            }
        }
    }
    return gInstance;
}

+ (void)orientationDidChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    BOOL didReload = [NUISettings reloadStylesheetsOnOrientationChange:orientation];

    if (didReload)
        [NUIRenderer rerender];
}

+ (void)stylesheetFileChanged
{
    [NUISettings loadStylesheetByPath:[NUISettings autoUpdatePath]];
    [NUIRenderer rerender];
    [CATransaction flush];
}

@end
