//
//  DingweiViewController.h
//  fenzhi
//
//  Created by lvxin on 2017/10/16.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sureDelegate <NSObject>
- (void)sure_click;
@end
@interface DingweiViewControlleroc : UIViewController
@property (nonatomic,copy) NSString *mainUrl;
@property (nonatomic,assign) id<sureDelegate> delegate;
@property (nonatomic,assign) BOOL isHeart;//教学 心得
@end
