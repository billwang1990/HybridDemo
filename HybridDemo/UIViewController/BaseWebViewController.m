//
//  BaseWebViewController.m
//  HybridDemo
//
//  Created by wangyaqing on 15/8/25.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import "BaseWebViewController.h"
#import "UIWebView+AddJavaScriptInterface.h"
#import "AppDelegate.h"
#import "URLParser.h"

#define kNewStartWebKey @""

@interface BaseWebViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
//private
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView setCustomDelegate:self];
    [self injectNativeObject];
    [self startLoadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLoadRequest
{
    if ([self.urlStr length] > 0) {
        if (self.connection) {
            [self.connection cancel];
        }
        else
        {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60*60];
            self.connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        }
    }
}

//注入对象实例
- (void)injectNativeObject
{
    __weak typeof(self) wSelf = self;
    [self.webView addJavascriptInterfaces:wSelf WithName:@"CurrentVC"];
}

#pragma mark UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showIndicatorWithContent:@"请稍候"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *url = request.URL;
    NSURL *currUrl = self.connection.currentRequest.URL;
    
    if (!url.host || !currUrl.host) {
        return NO;
    }
    
    if (![url.host isEqualToString:currUrl.host] || ![url.path isEqualToString:currUrl.path]) {
        
        
        BaseWebViewController *childVC = [[BaseWebViewController alloc] initWithNibName:@"BaseWebViewController" bundle:nil];
        childVC.urlStr = request.URL.absoluteString;
        
        URLParser *parse = [[URLParser alloc]initWithURLString:childVC.urlStr];
        NSString *val = [parse valueForVariable:@"newPage"];

        if ([val isEqualToString:@"true"]) {
            [self performSelector:@selector(changeToRootVC:) withObject:childVC afterDelay:0.5];
            return NO;
        }
        else
        {
            if (self.navigationController) {
                [self.navigationController pushViewController:childVC animated:YES];
            }
            else
            {
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
            return NO;
        }

    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideIndicator];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)changeToRootVC:(UIViewController*)vc
{
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    del.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    [del.window makeKeyAndVisible];
}

#pragma mark NSURLConnection

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSURLResponse class]]) {
        NSInteger statusCode =  [(NSHTTPURLResponse*)response statusCode];
        if (statusCode < 200 || statusCode >= 300) {
            NSLog(@"%s request to %@ failed with statusCode=%ld", __FUNCTION__, response.URL.absoluteString, (long)statusCode);
        } else {
            
            [self.webView loadRequest:connection.originalRequest];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error) {
        //error handle
    }
}


@end
