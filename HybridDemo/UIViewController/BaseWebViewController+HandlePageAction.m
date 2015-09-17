//
//  BaseWebViewController+HandlePageAction.m
//  HybridDemo
//
//  Created by Yaqing Wang on 9/17/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import "BaseWebViewController+HandlePageAction.h"
#import "URLParser.h"
#import "CommonUtil.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

static void *kMenuKey = &kMenuKey;
@implementation BaseWebViewController (HandlePageAction)

@dynamic menuPopover;

- (void)generateRightItems:(NSArray *)items
{
    if (items.count == 1) {
        NSDictionary *obj = items[0];
        NSString *title = obj[@"name"];
        NSString *action = obj[@"action"];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(handleAction:)];
        self.navigationItem.rightBarButtonItem = barItem;
        
        objc_setAssociatedObject(barItem, @selector(handleAction:), action, OBJC_ASSOCIATION_COPY);
    }
    else {
        [self addPopMenu:items];
    }
}

- (void)addPopMenu:(NSArray*)items
{
    if (items.count > 1) {
        objc_setAssociatedObject(self, kMenuKey, items, OBJC_ASSOCIATION_RETAIN);
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(handleClickMultiMenus:)];
        self.navigationItem.rightBarButtonItem = barItem;
    }
}

- (void)handleClickMultiMenus:(UIBarButtonItem*)bar
{
    [self.menuPopover dismissMenuPopover];
    
    NSArray *items = objc_getAssociatedObject(self, kMenuKey);
    NSMutableArray *names = [[NSMutableArray alloc]initWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [names addObject:obj[@"name"]];
    }];
    self.menuPopover = [[MLKMenuPopover alloc]initWithFrame:CGRectMake(185, 0, 130, 40*items.count + 4)
                                                  menuItems:names];
    
    id<MLKMenuPopoverDelegate> del = self;
    self.menuPopover.menuPopoverDelegate = del;
    [self.menuPopover showInView:self.view];
}

- (void)handleAction:(UIBarButtonItem*)bar
{
    NSString *action = objc_getAssociatedObject(bar, @selector(handleAction:));
    
    if (action.length > 0) {
        [self gotoPage:action];
    }
}

- (void)gotoPage:(NSString*)page
{
    
    NSString *baseURL = [CommonUtil baseURL];
    if (![baseURL hasSuffix:@"/"]) {
        baseURL = [baseURL stringByAppendingString:@"/"];
    }
    
    if ([page hasPrefix:@"/"]) {
        page = [page substringFromIndex:1];
    }
    
    [self handleGotoPage:[NSString stringWithFormat:@"%@%@", baseURL, page]];
}

- (void)handleGotoPage:(NSString*)url
{
    BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithNibName:@"BaseWebViewController" bundle:nil];
    webVC.urlStr = url;
    URLParser *parse = [[URLParser alloc]initWithURLString:webVC.urlStr];
    NSString *val = [parse valueForVariable:@"newPage"];
    
    if ([val isEqualToString:@"true"]) {
        [self performSelector:@selector(changeToRootVC:) withObject:webVC afterDelay:0.5];
    }
    else
    {
        if (self.navigationController) {
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else
        {
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:webVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)changeToRootVC:(UIViewController*)vc
{
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    del.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    [del.window makeKeyAndVisible];
}

- (void)setMenuPopover:(MLKMenuPopover *)menuPopover
{
    objc_setAssociatedObject(self, @selector(menuPopover), menuPopover, OBJC_ASSOCIATION_RETAIN);
}

- (MLKMenuPopover *)menuPopover
{
    return objc_getAssociatedObject(self, @selector(menuPopover));
}

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    NSArray *actions = objc_getAssociatedObject(self, kMenuKey);
    NSDictionary *obj = [actions objectAtIndex:selectedIndex];
    [self gotoPage:obj[@"action"]];
}


@end
