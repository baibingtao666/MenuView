//
//  ViewController.m
//  MenuViewDemo
//
//  Created by 巴图 on 2019/1/25.
//  Copyright © 2019 巴图. All rights reserved.
//

#import "ViewController.h"
//#import "SecondViewController.h"
#import "MenuView.h"

@interface ViewController ()
@property (nonatomic, strong) MenuView *menuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = UIColor.orangeColor;
    self.menuView = [[MenuView alloc] initMenuWithDependencyView:self.view MenuView:view];
}

- (IBAction)action:(UIButton *)sender {
    [self.menuView menuShow];
}

@end
