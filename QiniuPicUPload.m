//
//  QiniuPicUPload.m
//  OC
//
//  Created by swkj_lsy on 17/3/3.
//  Copyright © 2017年 thidnet. All rights reserved.
//

#import "QiniuPicUPload.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QiniuSDK.h>
#import <MBProgressHUD.h>
//typedef void (^CallBackBlock)();

@implementation QiniuPicUPload
{
    MBProgressHUD * HUD;
    NSMutableArray *_imageDataArray;
    QNUploadManager * _upManager;
    NSString * _qiNiuToken;
    BOOL _cancelUpLoad;
    NSDictionary * _uploadImageDic;
    BOOL _isSuccess;
    
}

- (id)initImage:(NSMutableArray *)imageArray QniuToken:(NSString *)qiniutoken QiniuParameters:(NSDictionary *)qiniuParameters {
    if (self = [super init]) {
 
        _uploadImageDic = qiniuParameters;
        _qiNiuToken = qiniutoken;
        _imageDataArray = imageArray;
        
    }
    return self;
}
- (void)start{
    BOOL isHttps = TRUE;
    QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = httpsZone;
    }];
    _upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [self createHUD];
    [self uploadImage:0];
    if (_isSuccess) {
        NSLog(@"成功2");
    }
 

    
    
}
- (void)uploadImage:(int)num {
    __block int i = num;
    __block BOOL can;
    __weak QiniuPicUPload *weakSelf = self;
 
    NSString * key = [self createGUID];
    [_upManager putData:_imageDataArray[i] key:key token:_qiNiuToken
               complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                   //                 NSLog(@"info的内容：%@", info);
                   //                  NSLog(@"resp的内容：%@", resp);
                   if (!info.error) {
                       i++;
                       if (i < _imageDataArray.count) {
//                           NSLog(@"看看：%d",i);
                           [self uploadImage:i];
                       }else{
                           HUD.hidden = YES;
                           can = YES;
                           weakSelf.callBackBlock(YES);
                         //这里是提示上传成功的提示框，你可以自己分装更改
                           [self showHudTitle:@"上传成功" toView:[UIApplication sharedApplication].keyWindow];
                           
                       }
                       
                   }else{
                       HUD.hidden = YES;
                       can = NO;
                       weakSelf.callBackBlock(NO);
                       if (_cancelUpLoad) {
                           
                           [self showHudTitle:@"取消上传" toView:[UIApplication sharedApplication].keyWindow];
                           
                       }else{
                           [self showHudTitle:@"上传失败" toView:[UIApplication sharedApplication].keyWindow];
                
                       }
                       _cancelUpLoad = NO;
                   }
               } option:[self createProgress:i]];
    if (can) {
        NSLog(@"成功1");
    }
    _isSuccess = can; 
}
-( QNUploadOption *)createProgress:(int)num{
    QNUploadOption * ImageOpt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD.progress = percent/_imageDataArray.count+(float)num/_imageDataArray.count;
        });
    } params:_uploadImageDic checkCrc:NO cancellationSignal:^BOOL{
        return _cancelUpLoad;
    }];
    
 
    return ImageOpt;
}

- (void)createHUD{
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelText = @"上传";
    HUD.labelFont = [UIFont systemFontOfSize:12];
    HUD.opacity = 0.9;
    HUD.margin = 15;
    [HUD show:YES];
    
}
- (void)showHudTitle:(NSString *)hudString toView:(UIView *)view
{
    // 显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(hudString, @"HUD message title");
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.opacity = 0.7;
    hud.margin = 12;
    [hud hide:YES afterDelay:1.2];
}
- (NSString *)createGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

@end
