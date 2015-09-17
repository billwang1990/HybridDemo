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

@implementation BaseWebViewController (HandlePageAction)
- (void)generateRightItems:(NSArray *)items
{
    NSMutableArray *rightBars = [[NSMutableArray alloc]initWithCapacity:items.count];
    
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[@"name"];
        NSString *action = obj[@"action"];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(handleAction:)];
        [rightBars addObject:barItem];
        objc_setAssociatedObject(barItem, @selector(handleAction:), action, OBJC_ASSOCIATION_COPY);
    }];
    self.navigationItem.rightBarButtonItems = rightBars;
}

- (void)handleAction:(UIBarButtonItem*)bar
{
    NSString *action = objc_getAssociatedObject(bar, @selector(handleAction:));
    
    if (action.length > 0) {
        
        NSString *baseURL = [CommonUtil baseURL];
        if (![baseURL hasSuffix:@"/"]) {
            baseURL = [baseURL stringByAppendingString:@"/"];
        }
        
        if ([action hasPrefix:@"/"]) {
            action = [action substringFromIndex:1];
        }
     
        [self handleGotoPage:[NSString stringWithFormat:@"%@%@", baseURL, action]];
    }
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

@end
