//
//  SGHUD.m
//  Functional_Example
//
//  Created by apple on 2020/10/9.
//  Copyright © 2020 bbbboy. All rights reserved.
//

#import "SGHUD.h"

#define KeyWindow [UIApplication sharedApplication].keyWindow
#define HUDHeight 200

static NSInteger delayTime = 2;
@implementation SGHUD

+ (instancetype)shareInstance{
    static SGHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SGHUD alloc] init];
    });
    return instance;
}

/**
 显示默认菊花(Window)
 */
+ (void)showLoading {
    ;
    [self show:nil inView:KeyWindow mode:SGHUDProgressModeLoading];
}

/**
 显示菊花在view上
 */
+ (void)showLoadingInView:(UIView *)view {
    [self show:nil inView:view mode:SGHUDProgressModeLoading];
}

//显示提示(Window)（2s后消失）
+(void)showMessage:(NSString *)msg {
    [self show:msg inView:KeyWindow mode:SGHUDProgressModelOnlyText];
    [[SGHUD shareInstance].hud hideAnimated:YES afterDelay:delayTime];
}

/**
 显示提示在View上 (2s后消失)
 */
+(void)showMessage:(NSString *)msg inView:(UIView *)view {
    [self show:msg inView:view mode:SGHUDProgressModelOnlyText];
    [[SGHUD shareInstance].hud hideAnimated:YES afterDelay:delayTime];
}

/**
 显示提示+图片在Window上
 */
+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:KeyWindow mode:SGHUDProgressModeCustomerImage customImgView:img];
    [[SGHUD shareInstance].hud hideAnimated:YES afterDelay:delayTime];
}

/**
 显示提示+图片在view上
 */
+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:SGHUDProgressModeCustomerImage customImgView:img];
    [[SGHUD shareInstance].hud hideAnimated:YES afterDelay:delayTime];
}

//显示自定义动画(自定义动画序列帧 Window)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry {
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:KeyWindow mode:SGHUDProgressModeCustomAnimation customImgView:showImageView];
}

//显示自定义动画(自定义动画序列帧 View)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view {
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:SGHUDProgressModeCustomAnimation customImgView:showImageView];
}

+ (void)show:(NSString *)msg inView:(UIView *)view mode:(SGHUDProgressModel)model
{
    [self show:msg inView:view mode:model customImgView:nil];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(SGHUDProgressModel)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹窗先消失
    if ([SGHUD shareInstance].hud != nil) {
        [[SGHUD shareInstance].hud hideAnimated:YES];
    }
    //屏幕避免键盘存在时遮挡
    [view endEditing:YES];
    
    [SGHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        
    //是否设置黑色背景，这两句配合使用
    [SGHUD shareInstance].hud.tintColor = [UIColor blackColor];
    [SGHUD shareInstance].hud.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HUDHeight);
    [SGHUD shareInstance].hud.center = view.center;
    [SGHUD shareInstance].hud.contentColor = [UIColor whiteColor];
    [[SGHUD shareInstance].hud setMargin:10];
    [[SGHUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
    [SGHUD shareInstance].hud.label.text = @" ";
    [SGHUD shareInstance].hud.label.font = [UIFont systemFontOfSize:11];
    [SGHUD shareInstance].hud.bezelView.color = [UIColor blackColor];
    [SGHUD shareInstance].hud.label.text = msg;
    [SGHUD shareInstance].hud.label.numberOfLines = 0;
    [SGHUD shareInstance].hud.label.font = [UIFont systemFontOfSize:14];
    
    [SGHUD shareInstance].hud.userInteractionEnabled = myMode != SGHUDProgressModelOnlyText;
    
    [SGHUD shareInstance].hud.animationType = MBProgressHUDAnimationZoomOut;
    switch ((NSInteger)myMode) {
        case SGHUDProgressModelOnlyText:
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeText;
            break;
        case SGHUDProgressModeLoading:
        {
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [(UIActivityIndicatorView *)indicator startAnimating];
            [SGHUD shareInstance].hud.customView = indicator;
        }
            break;
        case SGHUDProgressModeCircle:
        {
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.toValue = [NSNumber numberWithFloat:M_PI*2];
            animation.duration = 1.0;
            animation.repeatCount = 100;
            [img.layer addAnimation:animation forKey:nil];
            [SGHUD shareInstance].hud.customView = img;
        }
            break;
        case SGHUDProgressModeCustomerImage:
        {
          [SGHUD shareInstance].hud.minSize = CGSizeMake(70, 40);
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [SGHUD shareInstance].hud.customView = customImgView;
        }
            break;
        case SGHUDProgressModeCustomAnimation:
        {
            //设置动画的背景色
            // [SGHUD shareInstance].hud.bezelView.color = [UIColor yellowColor];
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [SGHUD shareInstance].hud.customView = customImgView;
        }
            break;
        case SGHUDProgressModeSuccess:
        {
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [SGHUD shareInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
        }
            
            break;
            
        case SGHUDProgressModeWraing:
        {
            [SGHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [SGHUD shareInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tanhao"]];
        }
            break;
        default:
            break;
    }
}

+ (void)hide {
    [[SGHUD shareInstance].hud hideAnimated:YES afterDelay:0.0];
}

@end
