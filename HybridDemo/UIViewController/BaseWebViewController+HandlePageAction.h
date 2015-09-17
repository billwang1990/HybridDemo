//
//  BaseWebViewController+HandlePageAction.h
//  HybridDemo
//
//  Created by Yaqing Wang on 9/17/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import "BaseWebViewController.h"
#import "MLKMenuPopover.h"

@interface BaseWebViewController (HandlePageAction)

@property (nonatomic, strong) MLKMenuPopover *menuPopover;

- (void)generateRightItems:(NSArray*)items;
- (void)handleGotoPage:(NSString*)url;

@end
