//
//  BaseViewController.m
//  HybridDemo
//
//  Created by wangyaqing on 15/8/25.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD.h>

#define kDefaultHudDuration 1

@interface BaseViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getter
- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDAnimationFade;
        _hud.tag = 777;
    }
    return _hud;
}

- (void)showHudWithTitle:(NSString *)title
{
    [self showHudWithTitle:title andDuration:kDefaultHudDuration];
}

- (void)showHudWithTitle:(NSString *)title andDuration:(NSTimeInterval)timeInterVal
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultHudDuration * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // Do something...
        [hud hide:YES];
        
    });
}

- (void)showIndicatorWithContent:(NSString *)msg
{
    self.hud.labelText = msg;
    self.hud.tag = 666;
    [self.hud show:YES];
}

- (void)hideIndicator
{
    [self.hud hide:YES];
    self.hud = nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
