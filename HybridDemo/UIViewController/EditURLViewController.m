//
//  EditURLViewController.m
//  HybridDemo
//
//  Created by Yaqing Wang on 9/16/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import "EditURLViewController.h"
#import "UINavigationItem+Addition.h"
#import "CommonUtil.h"


@interface EditURLViewController ()

@property (nonatomic, strong) UITextField *inputURL;

@end

@implementation EditURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改主机";
    
    [self.navigationItem setNavigationBarItemWithTitle:@"保存" andTarget:self action:@selector(save) isLeftItem:NO];
    [self.navigationItem setNavigationBarItemWithTitle:@"返回" andTarget:self action:@selector(dismissSelf) isLeftItem:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.inputURL = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.inputURL.center = self.view.center;
    self.inputURL.placeholder = @"输入URL";
    self.inputURL.textAlignment = NSTextAlignmentCenter;
    self.inputURL.borderStyle = UITextBorderStyleRoundedRect;
    self.inputURL.text = [CommonUtil baseURL];
    [self.view addSubview:self.inputURL];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.tintColor = [UIColor orangeColor];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    resetBtn.backgroundColor = [UIColor blueColor];
    resetBtn.frame = CGRectMake(40, CGRectGetMaxY(self.inputURL.frame)+30, 240, 35);
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:resetBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reset{
    [CommonUtil resetURL];
    [self showHudWithTitle:@"重置成功"];
    [self completeAction];
}

- (void)completeAction
{
    typeof(self) wSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (wSelf.completeBlk) {
            wSelf.completeBlk([CommonUtil baseURL]);
        }
    }];
}

- (void)save{
    if (self.inputURL.text.length == 0 ) {
        return;
    }
    
    [self showHudWithTitle:([CommonUtil setURL:self.inputURL.text]?@"保存成功":@"保存失败")];
    [self completeAction];
}

@end
