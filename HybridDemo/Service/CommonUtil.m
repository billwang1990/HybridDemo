//
//  CommonUtil.m
//  HybridDemo
//
//  Created by Yaqing Wang on 9/16/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import "CommonUtil.h"
#import <BlocksKit+UIKit.h>

static CommonUtil *instance = nil;

@interface CommonUtil()

@property (nonatomic, copy) NSString *baseURL;

@end

@implementation CommonUtil

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CommonUtil alloc]init];
    });
    return instance;
}

+ (NSString *)baseURL
{
    return [CommonUtil shareInstance].baseURL;
}

+ (BOOL)setURL:(NSString *)URL
{
    if (![self validateURL:URL]) {
        return NO;
    }
    
    if ([URL hasPrefix:@"http://"]) {
        [CommonUtil shareInstance].baseURL = [URL copy];
    }
    else
    {
        [CommonUtil shareInstance].baseURL = [NSString stringWithFormat:@"http://%@",URL];
    }
    return YES;
}

+ (void)resetURL{
    [CommonUtil shareInstance].baseURL = kRootURL;
}

+ (BOOL)validateURL:(NSString*)URL{
    return YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        _baseURL = kRootURL;
    }
    return self;
}

@end
