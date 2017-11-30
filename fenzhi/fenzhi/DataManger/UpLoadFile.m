//
//  UpLoadFile.m
//  fenzhi
//
//  Created by lvxin on 2017/11/30.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

#import "UpLoadFile.h"
#import <AliyunOSSiOS/OSSService.h>

OSSClient * client;
@implementation UpLoadFile


- (void)initOSSClient: (NSString *) key sec :(NSString*)scr Token : (NSString *)token {

    NSString * endpoint = @"http://oss-cn-beijing.aliyuncs.com";

    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:key secretKeyId:scr securityToken:token];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
    
}

- (void)upLoadImage:(NSData *)imageData imageName:(NSString *) imageName{
    NSLog(@"%lu",(unsigned long)imageData.length);
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"fenzhi-image";
    put.uploadingData = imageData;
    put.objectKey = [NSString stringWithFormat:@"avatar/1/%@.jpg",imageName];
    OSSTask * createTask = [client putObject:put];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
            NSString * name = [NSString stringWithFormat:@"http://fenzhi-image.oss-cn-beijing.aliyuncs.com/avatar/1/%@.jpg",imageName];
            [self.delegate complete:name];
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}
@end
