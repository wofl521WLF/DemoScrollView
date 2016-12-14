//
//  ViewController.m
//  DemoScrollView
//
//  Created by 吴林丰 on 2016/12/14.
//  Copyright © 2016年 吴林丰. All rights reserved.
//

#import "ViewController.h"

//屏幕宽高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEFAULT_VOID_COLOR ([UIColor blackColor])


@interface ViewController ()
// 滚动视图
@property (strong,nonatomic) UIScrollView *scrollview;
@property (strong,nonatomic) UIScrollView *scrollview2;
//视图中的label数组
@property (strong,nonatomic) NSMutableArray *labelArr;

@end

@implementation ViewController

//懒加载控件
- (UIScrollView *)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT/2)];
        _scrollview.canCancelContentTouches = NO;//设置取消触摸
        _scrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;//设置滚动条颜色
        _scrollview.layer.masksToBounds = YES;//超出部分自动裁剪
        _scrollview.scrollEnabled = YES;//设置是否可以缩放
        _scrollview.pagingEnabled = YES;//设置可以进行画面切换
        _scrollview.directionalLockEnabled = YES;//设置在拖拽的时候是否锁定其水平或者垂直方向
        
        //设置是否隐藏滚动条
        _scrollview.alwaysBounceVertical = NO;
        _scrollview.alwaysBounceHorizontal = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = YES;
    }
    return _scrollview;
}

- (UIScrollView *)scrollview2{
    if (_scrollview2 == nil) {
        _scrollview2 = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollview2.showsVerticalScrollIndicator = YES;
        _scrollview2.showsHorizontalScrollIndicator = NO;
        _scrollview2.hidden = YES;
        _scrollview2.pagingEnabled = YES;//设置可以进行画面切换
        _scrollview2.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    }
    return _scrollview2;
}

- (NSMutableArray *)labelArr{
    if (_labelArr == nil) {
        _labelArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _labelArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark ----- 创建UI
- (void)createUI{
    [self.view addSubview:self.scrollview];
    [self.view addSubview:self.scrollview2];
    self.labelArr = [@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"] mutableCopy];
    //设置滚动方法
    [self createScrollViewMethod];
    [self createScrollViewMethodVertical];
    [self seguUI];
}

//创建一个头部切换UISegmentedControl 用于切换
- (void)seguUI{
    //设置头部可切换View,为保证改变Frame后Segement仍然能够居中显示，所以将segement放在一个View上，view作为TitleView的容器
    UISegmentedControl *segement = [[UISegmentedControl alloc]initWithItems:@[@"水平滑动",@"垂直滑动"]];
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segement setTitleTextAttributes:attributes
                            forState:UIControlStateNormal];
    segement.tintColor = [self colorWithHexString:@"#fc6760"];
    [segement addTarget:self action:@selector(seggementValueChanged:) forControlEvents:UIControlEventValueChanged];
    segement.selectedSegmentIndex = 0;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,160, 30)];
    [titleView addSubview:segement];
    self.navigationItem.titleView = titleView;


}

#pragma mark ----- 水平滑动
- (void)createScrollViewMethod{
    NSInteger pages = 0;//用来记录页数
    float originx = 0.0;
    for (NSInteger i = 0; i<self.labelArr.count; ++i) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageview.backgroundColor = [UIColor clearColor];
        CGRect frame = self.scrollview.frame;
        frame.origin.x = originx;
        frame.origin.y = 0;
        frame.size.height -= 64;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:self.labelArr[i]];
        //将Label加入到滚动视图中
        imageview.frame = frame;
        imageview.layer.masksToBounds = YES;
        [self.scrollview addSubview:imageview];
        //每个label都放在前一个label最后
        originx += SCREEN_WIDTH;
        pages ++;
    }
    self.scrollview.contentSize =  CGSizeMake(originx,0);
}

#pragma mark ---- 垂直滑动
- (void)createScrollViewMethodVertical{
    NSInteger pages = 0;//用来记录页数
    float originY = 0.0;
    for (NSInteger i = 0; i<self.labelArr.count; ++i) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageview.backgroundColor = [UIColor clearColor];
        CGRect frame = self.scrollview2.frame;
        frame.origin.x = 0;
        frame.origin.y = originY;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:self.labelArr[i]];
        //将Label加入到滚动视图中
        imageview.frame = frame;
        imageview.layer.masksToBounds = YES;
        [self.scrollview2 addSubview:imageview];
        //每个label都放在前一个label最后
        originY += frame.size.height;
        pages ++;
    }
    self.scrollview2.contentSize =  CGSizeMake(0,originY);
}

#pragma  mark --- 点击头部切换不同状态ScrollView 视图滚动方式
-(void)seggementValueChanged:(UISegmentedControl *)Seg
{
    if (Seg.selectedSegmentIndex == 1) {
        self.scrollview2.hidden = NO;
        self.scrollview.hidden = YES;
    }else{
        self.scrollview.hidden = NO;
        self.scrollview2.hidden = YES;
    }
}



#pragma mark ---- 便于以后工作使用的颜色方法，根据UI的一串数字就能得到相应的颜色
- (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
