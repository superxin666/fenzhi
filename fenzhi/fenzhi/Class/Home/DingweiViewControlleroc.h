//
//  DingweiViewController.h
//  fenzhi
//
//  Created by lvxin on 2017/10/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
//NSString * name,NSString * couseid
typedef void (^DingweiViewControllerocblock)();

@interface DingweiViewControlleroc : UIViewController
@property (nonatomic,copy) NSString *mainUrl;
@property (nonatomic,assign)DingweiViewControllerocblock sureBlock;
@end
