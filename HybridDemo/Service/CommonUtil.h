//
//  CommonUtil.h
//  HybridDemo
//
//  Created by Yaqing Wang on 9/16/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRootURL @"http://www.ourbala.com/"

@interface CommonUtil : NSObject

+ (instancetype)shareInstance;
+ (NSString*)baseURL;
+ (BOOL)setURL:(NSString*)URL;
+ (void)resetURL;

@end
