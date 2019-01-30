# MenuView
MenuView / 侧边栏


![展示](https://github.com/MaxBT6/MenuView/blob/master/menu.gif)


### 初始化
```
//也可以是tableView 展示侧边栏
UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height)];
view.backgroundColor = UIColor.orangeColor;
self.menuView = [[MenuView alloc] initMenuWithDependencyView:self.view MenuView:view];
```

### menu 展示
```
[self.menuView menuShow];
```
或者从屏幕左边缘又划

### menu 隐藏
点击遮罩处 
或者手势左滑
默认带动画.

