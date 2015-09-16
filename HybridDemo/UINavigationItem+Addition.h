//
//  UINavigationItem+Addition.h
//  HybridDemo
//
//  Created by Yaqing Wang on 9/16/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Addition)

- (UIBarButtonItem*)setNavigationBarItemWithImage:(UIImage *)image andTarget:(id)target action:(SEL)action isLeftItem:(BOOL)isLeft;

- (UIBarButtonItem *)setNavigationBarItemWithTitle:(NSString *)title andTarget:(id)target action:(SEL)action isLeftItem:(BOOL)isLeft;

@end
