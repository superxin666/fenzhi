//
//  DingweiViewController.m
//  fenzhi
//
//  Created by lvxin on 2017/10/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//


#import "DingweiViewControlleroc.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "fenzhi-Swift.h"
@interface DingweiViewControlleroc ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (strong, nonatomic) JSContext *context;
@end

@implementation DingweiViewControlleroc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"课时定位";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back_click)];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.allowsInlineMediaPlayback = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_mainUrl]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
}


- (void)back_click{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    // Undocumented access to UIWebView's JSContext
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 打印异常
    self.context.exceptionHandler =^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    

    //1.关闭当前页面
     __weak __typeof(self)weakself = self;
    self.context[@"cancle_click"] =^()
    {
        NSLog(@"取消");
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself  back_click];
        });

    };
    
    //2.获取App版本号
    self.context[@"save_click"] =^(NSString * catid, NSString * name){
        NSLog(@"id%@",catid);
        NSLog(@"名字%@",name);

    
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"setSelectCouse_name"];
//                [[NSUserDefaults standardUserDefaults] setObject:catid forKey:@"setSelectCouse_id"];
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isHaveSelectCouseinfo"];
//                BOOL isok =  [NSUserDefaults.standardUserDefaults synchronize];
                weakself.sureBlock();
                [weakself  back_click];
            });

    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
