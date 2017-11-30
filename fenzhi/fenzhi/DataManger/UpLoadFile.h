//
//  UpLoadFile.h
//  fenzhi
//
//  Created by lvxin on 2017/11/30.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol UpLoadFileDelegate <NSObject>
- (void)complete : (NSString *)filename;
@end
@interface UpLoadFile : NSObject
@property (nonatomic,assign) id<UpLoadFileDelegate> delegate;
- (void)initOSSClient: (NSString *) key sec :(NSString*)scr Token : (NSString *)token;
- (void) upLoadImage : (NSData *) imageData imageName:(NSString *) imageName;
@end
