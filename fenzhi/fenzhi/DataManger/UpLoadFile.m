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

- (void) upLoadFile : (NSData *) fileData fileName:(NSString *) fileName loadName : (NSString *) loadName{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"fenzhi-image";
    put.uploadingData = fileData;
    put.objectKey = [NSString stringWithFormat:@"share/1/%@",loadName];
    put.contentDisposition = [NSString stringWithFormat:@"attachment;filename=%@",fileName];

    
    OSSTask * createTask = [client putObject:put];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
            NSString * name = [NSString stringWithFormat:@"http://fenzhi-image.oss-cn-beijing.aliyuncs.com/share/1/%@",loadName];
            [self.delegatefile complete_fileName:fileName loadName:name];
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
    
    
}
@end
