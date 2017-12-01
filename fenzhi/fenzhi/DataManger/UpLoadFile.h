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

@protocol UpLoadFileDelegate_file <NSObject>
- (void)complete_fileName : (NSString *)filename loadName : (NSString* )loadName;
@end


@interface UpLoadFile : NSObject
@property (nonatomic,assign) id<UpLoadFileDelegate> delegate;
@property (nonatomic,assign) id<UpLoadFileDelegate_file> delegatefile;
- (void)initOSSClient: (NSString *) key sec :(NSString*)scr Token : (NSString *)token;
- (void) upLoadImage : (NSData *) imageData imageName:(NSString *) imageName;
- (void) upLoadFile : (NSData *) fileData fileName:(NSString *) fileName loadName : (NSString *) loadName;
@end
