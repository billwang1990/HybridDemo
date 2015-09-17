//
//  BaseWebViewController.h
//  HybridDemo
//
//  Created by wangyaqing on 15/8/25.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import "BaseViewController.h"
#import "MLKMenuPopover.h"
@interface BaseWebViewController : BaseViewController<MLKMenuPopoverDelegate>

@property (nonatomic, copy) NSString *urlStr;

- (void)setRightNavBarItems:(NSArray*)items;

@end
