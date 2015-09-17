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
#import "EditURLViewController.h"
#import "BaseWebViewController+HandlePageAction.h"

@interface BaseWebViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
//private
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, assign) BOOL isEditing;

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

- (void)setRightNavBarItems:(NSArray *)items
{
    if (items.count > 0) {
        [self generateRightItems:items];
    }
}

//注入对象实例
- (void)injectNativeObject
{
    __weak typeof(self) wSelf = self;
    [self.webView addJavascriptInterfaces:wSelf WithName:@"CurrentViewController"];
}

#pragma mark UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showIndicatorWithContent:@"请稍候"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSURL *currUrl = self.webView.request.URL;
    if (!currUrl.host) {
        return YES;
    }
    if (!url.host) {
        //url maybe about:blank
        return NO;
    }
    
    if (self.isEditing) {
        self.isEditing = NO;
        return YES;
    }

    if (![url.host isEqualToString:currUrl.host] || ![url.path isEqualToString:currUrl.path]) {
        [self handleGotoPage:request.URL.absoluteString];
        return NO;
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

#if DEBUG
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"test" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:js];
#endif
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

#pragma mark shake motion handle 

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (self.isEditing) {
        return;
    }
    self.isEditing = YES;

    typeof(self) wSelf = self;
    EditURLViewController *vc = [[EditURLViewController alloc]init];
    vc.completeBlk = ^(NSString*host){
        
        if ([host hasSuffix:@"/"]) {
            host = [host substringToIndex:host.length - 1];
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",host, wSelf.webView.request.URL.path?:@""];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60*60];
        [wSelf.webView loadRequest:request];
    };
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
