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
    [self.navigationItem setNavigationBarItemWithTitle:@"保存" andTarget:self action:@selector(save) isLeftItem:NO];
    
    self.inputURL = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.inputURL.center = self.view.center;
    self.inputURL.placeholder = @"输入URL";
    
    [self.view addSubview:self.inputURL];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.tintColor = [UIColor orangeColor];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    
    resetBtn.frame = CGRectMake(20, CGRectGetMaxY(self.inputURL.frame), 280, 35);
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:resetBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reset{
    [CommonUtil resetURL];
    [self showHudWithTitle:@"重置成功"];
}

- (void)save{
    if (self.inputURL.text.length == 0 ) {
        return;
    }
    
    [self showHudWithTitle:([CommonUtil setURL:self.inputURL.text]?@"保存成功":@"保存失败")];
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
