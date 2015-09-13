//
//  BaseViewController.h
//  HybridDemo
//
//  Created by wangyaqing on 15/8/25.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  hud提示 会自动消失
 *
 *  @param title 文字内容，默认时间
 */
- (void)showHudWithTitle:(NSString*)title;

/**
 *  hud提示，不会自动消失
 *
 *  @param msg 内容
 */
- (void)showIndicatorWithContent:(NSString*)msg;

/**
 *  隐藏hud 提示
 */
- (void)hideIndicator;

@end
