//
//  QiniuPicUPload.h
//  OC
//
//  Created by swkj_lsy on 17/3/3.
//  Copyright © 2017年 thidnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
typedef void (^CallBackBlock)(BOOL can);
@interface QiniuPicUPload : NSObject
@property (nonatomic,copy)CallBackBlock callBackBlock;
/**
 *  @param imageArray 下载或上传进度的回调
 *  @param qiniutoken  成功的回调
 *  @param qiniuParameters  失败的回调
 */
- (id)initImage:(NSMutableArray *)imageArray QniuToken:(NSString *)qiniutoken QiniuParameters:(NSDictionary *)qiniuParameters;
- (void)start;
@end
