//
//  MenuView.h
//  MenuViewDemo
//
//  Created by 巴图 on 2019/1/25.
//  Copyright © 2019 巴图. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView;

NS_ASSUME_NONNULL_BEGIN

@interface MenuView : UIView

/*
 *  是否展示阴影遮罩
 */
@property (nonatomic, assign) BOOL isCoverShow;
/*
 *  Cover 颜色
 */
@property (nonatomic, strong) UIColor *coverColor;
/*
 *  Cover 透明度
 */
@property (nonatomic, assign) CGFloat coverAlpha;

@property (nonatomic, assign, readonly) BOOL isShow;

/**
 *  初始化方法
 *
 *  @param dependencyView 传入需要滑出菜单的控制器的view
 *  @param menuView       传入需要显示的菜单的view
 *
 *  @return self
 */
+ (instancetype)MenuWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)menuView;

/**
 *  初始化方法
 *
 *  @param dependencyView 传入需要滑出菜单的控制器的view
 *  @param menuView       传入需要显示的菜单的view
 *
 *  @return self
 */
- (instancetype)initMenuWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)menuView;

/**
 *  打开菜单
 */
- (void)menuShow;

/**
 *  关闭菜单
 *
 *  @param animation 是否动画
 */
- (void)menuHiddenWithAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
