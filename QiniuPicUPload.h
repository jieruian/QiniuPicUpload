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
 *  @param imageArray  保存图片信息的data数组（注意是data数组）
 *  @param qiniutoken  七牛的token
 *  @param qiniuParameters  提交给七牛的数据（就是一个字典x: ）
 */
- (id)initImage:(NSMutableArray *)imageArray QniuToken:(NSString *)qiniutoken QiniuParameters:(NSDictionary *)qiniuParameters;
- (void)start;
@end
