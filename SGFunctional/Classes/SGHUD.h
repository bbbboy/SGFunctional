//
//  SGHUD.h
//  Functional_Example
//
//  Created by apple on 2020/10/9.
//  Copyright © 2020 bbbboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SGHUDProgressModel){
    SGHUDProgressModelOnlyText,   //文字
    SGHUDProgressModeLoading,     //加载菊花
    SGHUDProgressModeCircle,      //加载环形
    SGHUDProgressModeCircleLoading,   //加载圆形-要处理进度值
    SGHUDProgressModeCustomAnimation,  //自定义加载动画（序列帧实现）
    SGHUDProgressModeSuccess,     //成功
    SGHUDProgressModeWraing,     //警告⚠️
    SGHUDProgressModeCustomerImage    //自定义图片
};

@interface SGHUD : NSObject

@property(nonatomic, strong) MBProgressHUD *hud;

+ (instancetype)shareInstance;

/**
 显示默认菊花(Window)
 */
+ (void)showLoading;

/**
 显示菊花在view上
 */
+ (void)showLoadingInView:(UIView *)view;

//显示提示(Window)（1s后消失）
+(void)showMessage:(NSString *)msg;

/**
 显示提示在View上 (1s后消失)
 */
+(void)showMessage:(NSString *)msg inView:(UIView *)view;

/**
 显示提示+图片在Window上
 */
+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName ;

/**
 显示提示+图片在view上
 */
+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view;

//显示自定义动画(自定义动画序列帧 Window)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry;

//显示自定义动画(自定义动画序列帧 View)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;

+ (void)hide;

@end

NS_ASSUME_NONNULL_END
