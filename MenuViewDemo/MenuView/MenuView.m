//
//  MenuView.m
//  MenuViewDemo
//
//  Created by 巴图 on 2019/1/25.
//  Copyright © 2019 巴图. All rights reserved.
//

#define kScreen_Width           [UIScreen mainScreen].bounds.size.width
#define kScreen_Height          [UIScreen mainScreen].bounds.size.height

#import "MenuView.h"

static UIWindow *window = nil;
double const AnimateDuration = 0.3;
NSString *const key_is_show = @"show";

@interface MenuView ()
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGRect menuFrame;
@property (nonatomic, assign) CGRect coverFrame;

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIView *coverView;
@end


@implementation MenuView

@synthesize isCoverShow = _isCoverShow;
@synthesize coverColor = _coverColor;
@synthesize coverAlpha = _coverAlpha;

+ (instancetype)MenuWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)menuView {
    MenuView *menu = [[MenuView alloc] initMenuWithDependencyView:dependencyView MenuView:menuView];
    return menu;
}

- (instancetype)initMenuWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)menuView {
    if (self = [super init]) {
        self.isCoverShow = YES;
        self.coverColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0];
        self.coverAlpha = 0.7f;
        self.show = NO;
        
        window = [[UIApplication sharedApplication].delegate window];
        [self addPanGestureAtDependencyView:dependencyView];
        
        self.menuView = menuView;
        self.menuFrame = menuView.frame;
        self.menuView.frame = CGRectMake(-self.menuFrame.size.width, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
        
        self.coverFrame = CGRectMake(self.menuFrame.origin.x, self.menuFrame.origin.y, kScreen_Width, self.menuFrame.size.height);
        
        [self addObserver:self forKeyPath:key_is_show options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:key_is_show]) {
        if (((MenuView *)object).isCoverShow) {
            [UIView animateWithDuration:AnimateDuration animations:^{
                ((MenuView *)object).coverView.hidden = !((MenuView *)object).show;
                ((MenuView *)object).coverView.alpha = ((MenuView *)object).show ? ((MenuView *)object).coverAlpha : 0.0f;
            }];
        }
    }
}

//setup UI
- (void)superViewAddChild {
    if (!self.coverView.superview) {
        [window addSubview:self.coverView];
    }
    
    if (!self.menuView.superview) {
        [window addSubview:self.menuView];
    }
}

#pragma mark - add Gesture
- (void)addPanGestureAtDependencyView:(UIView *)dependencyView {
    //屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    //屏幕左侧边缘响应
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [dependencyView addGestureRecognizer:leftEdgeGesture];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    [self superViewAddChild];
    
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged) {
        if (translation.x == 0) {
            self.show = NO;
            self.menuView.frame = CGRectMake(-self.menuFrame.size.width, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
        }else if (translation.x <= self.menuFrame.size.width) {
            self.show = YES;
            self.menuView.frame = CGRectMake(translation.x - self.menuFrame.size.width, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
        }else {
            self.show = YES;
            self.menuView.frame = self.menuFrame;
        }
    }else {
        if (translation.x > self.menuFrame.size.width / 2) {
            [self openMenu];
        }else {
            [self closeMenu];
        }
    }
}

- (void)openMenu {
    [self menuShow];
}

- (void)closeMenu {
    [self menuHiddenWithAnimation:YES];
}

#pragma mark - menu show
- (void)menuShow {
    [self superViewAddChild];
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:AnimateDuration animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.menuView.frame = strongSelf.menuFrame;
        strongSelf.coverView.alpha = strongSelf.coverAlpha;
    }];
    
    self.show = YES;
}

#pragma mark - menu hidden
- (void)menuHiddenWithAnimation:(BOOL)animation {
    if (animation) {
        [self removeMenuFromWindow];
    }else {
        [self coverTapAction];
    }
}

- (void)removeMenuFromWindow {
    self.menuView.frame = CGRectMake(-self.menuFrame.size.width, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
    self.coverView.alpha = 0;
    
    [self.menuView removeFromSuperview];
    [self.coverView removeFromSuperview];
    
    self.show = NO;
}

#pragma mark - cover tapgesture action
- (void)coverTapAction {
    __weak __typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:AnimateDuration delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.menuView.frame = CGRectMake(-strongSelf.menuFrame.size.width, strongSelf.menuFrame.origin.y, strongSelf.menuFrame.size.width, strongSelf.menuFrame.size.height);
        strongSelf.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.menuView removeFromSuperview];
        [strongSelf.coverView removeFromSuperview];
    }];
    
    self.show = NO;
}

#pragma mark - cover pangesture action
- (void)coverPanAction:(UIPanGestureRecognizer *)gesture {
    static CGFloat began_x;
    CGPoint translation = [gesture translationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //手势开始的偏移量
        began_x = translation.x;
    }
    //去掉偏移量
    CGFloat offset = (-translation.x) - (-began_x);
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged) {
        if (offset <= self.menuView.frame.size.width && offset > 0) {
            self.show = YES;
            self.menuView.frame = CGRectMake(-offset, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
        }else if (offset > self.menuView.frame.size.width) {
            self.show = NO;
            self.menuView.frame = CGRectMake(-self.menuFrame.size.width, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
        }else {
            self.show = YES;
            self.menuView.frame = CGRectMake(0, self.menuFrame.origin.y, self.menuFrame.size.width, self.menuFrame.size.height);
        }
    }else {
        if(offset > self.menuFrame.size.width / 2){
            [self closeMenu];
        }else{
            [self openMenu];
        }
    }
}

#pragma mark - setter
- (void)setIsCoverShow:(BOOL)isCoverShow {
    _isCoverShow = isCoverShow;
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
}

- (void)setCoverAlpha:(CGFloat)coverAlpha {
    _coverAlpha = coverAlpha;
}

- (void)setShow:(BOOL)show {
    _show = show;
}

#pragma mark - getter
- (BOOL)isCoverShow {
    return _isCoverShow;
}

- (UIColor *)coverColor {
    if (_isCoverShow) {
        return _coverColor;
    }else {
        return UIColor.clearColor;
    }
}

- (CGFloat)coverAlpha {
    if (_isCoverShow) {
        return _coverAlpha;
    }else {
        return 1.0f;
    }
}

- (BOOL)isShow {
    return _show;
}

#pragma mark - lazy
- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:self.menuFrame];
    }
    return _menuView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.coverFrame];
        _coverView.backgroundColor = self.coverColor;
        _coverView.alpha = 0;
        _coverView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTapAction)];
        [_coverView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(coverPanAction:)];
        [_coverView addGestureRecognizer:pan];
        
        [tap requireGestureRecognizerToFail:pan];
    }
    return _coverView;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:key_is_show];
}

@end
