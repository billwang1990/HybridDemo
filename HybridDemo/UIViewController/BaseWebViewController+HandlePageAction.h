//
//  BaseWebViewController+HandlePageAction.h
//  HybridDemo
//
//  Created by Yaqing Wang on 9/17/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController (HandlePageAction)

- (void)generateRightItems:(NSArray*)items;
- (void)handleGotoPage:(NSString*)url;

@end
