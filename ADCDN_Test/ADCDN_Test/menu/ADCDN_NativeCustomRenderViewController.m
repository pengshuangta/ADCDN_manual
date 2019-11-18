//
//  ADCDN_NativeCustomRenderViewController.m
//  ADCDN_APP
//
//  Created by 彭双塔 on 2019/10/30.
//  Copyright © 2019 pst. All rights reserved.
//

#import "ADCDN_NativeCustomRenderViewController.h"
#import <ADCDN/ADCDN.h>

#import "Tool/ADCDN_StringStyleTool.h"

#define ScreenW self.view.frame.size.width
#define ScreenH self.view.frame.size.height

#define kAppId @"1030013"
#define kPlcId @"1010163"

static CGFloat const margin = 15;
static UIEdgeInsets const padding = {10, 15, 10, 15};

@interface ADCDN_NativeCustomRenderViewController ()<ADCDN_NativeCustomRenderAdManagerDelegate>

// 自定义视图
@property (nonatomic, strong) UIView *customView;


/**
 *  大图
 */
// 主标题
@property (nonatomic, strong) UILabel *adTitleLabel;
// 图1
@property (nonatomic, strong) UIImageView *adImageView1;
// 副标题
@property (nonatomic, strong) UILabel *adDescriptionLabel;
/**
 *   组图
 */
// 图2
@property (nonatomic, strong) UIImageView *adImageView2;
// 图3
@property (nonatomic, strong) UIImageView *adImageView3;
// 广告来源
@property (nonatomic, strong) UILabel *adSourceLabel;
/**
 *   单图
 */
// 广告
@property (nonatomic, strong) UILabel *adLabel;
@end

@implementation ADCDN_NativeCustomRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置view的y值从导航栏以下开始计算为y = 0
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"加载" style:UIBarButtonItemStylePlain target:self action:@selector(loadAd)];
    self.navigationItem.rightBarButtonItem = button;
    
}
/**
 *  懒加载
 */
#pragma mark - 广告父视图
-(UIView *)customView{
    if (!_customView) {
        _customView = [UIView new];
        _customView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_customView];
    }
    return _customView;
}

/*
 BUFeedADModeSmallImage = 2, 左图右文
 BUFeedVideoAdModeImage = 5, 视频
 */
#pragma mark - 大图
-(void)setUILargeModel:(ADCDN_NativeCustomRenderModel *)model{
    if (self.customView.superview) {
        [self.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    CGFloat width = ScreenW;
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    // 主标题
    NSAttributedString *attributedText = [ADCDN_StringStyleTool titleAttributeText:model.adTitle];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    self.adTitleLabel = [UILabel new];
    self.adTitleLabel.numberOfLines = 0;
    self.adTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.adTitleLabel.frame = CGRectMake(padding.left, y , contentWidth, titleSize.height);
    self.adTitleLabel.attributedText = attributedText;
    
    y += titleSize.height;
    y += 5;
    // 广告图
    ADCDN_NativeCustomRenderImage *image = [model.adImageAry firstObject];
    const CGFloat imageHeight = contentWidth * (image.height / image.width);
    self.adImageView1 = [UIImageView new];
    self.adImageView1.frame = CGRectMake(padding.left, y, contentWidth, imageHeight);
    self.adImageView1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageURL]]];
   
    y += imageHeight;
    y += 10;
   
    // 副标题
    CGFloat maxInfoWidth = width - 2 * margin;
    self.adDescriptionLabel = [UILabel new];
    self.adDescriptionLabel.frame = CGRectMake(padding.left , y , maxInfoWidth, 20);
    self.adDescriptionLabel.attributedText = [ADCDN_StringStyleTool subtitleAttributeText:model.adDesc];
    
    [self.customView addSubview:self.adTitleLabel];
    [self.customView addSubview:self.adDescriptionLabel];
    [self.customView addSubview:self.adImageView1];
    
    // 设置customView的高度，相当于tableview列表中的cell.contentView,刷新cell的rowHeight
    CGFloat customViewHeigth = y + padding.bottom + self.adDescriptionLabel.frame.size.height;
    self.customView.frame = CGRectMake(0, 100, ScreenW, customViewHeigth);
   
}
#pragma mark - 组图(三小图)
-(void)setUIGroupModel:(ADCDN_NativeCustomRenderModel *)model{
    if (self.customView.superview) {
        [self.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    CGFloat width = ScreenW;
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    // 主标题
    NSAttributedString *attributedText = [ADCDN_StringStyleTool titleAttributeText:model.adTitle];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    self.adTitleLabel = [UILabel new];
    self.adTitleLabel.numberOfLines = 0;
    self.adTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.adTitleLabel.frame = CGRectMake(padding.left, y , contentWidth, titleSize.height);
    self.adTitleLabel.attributedText = attributedText;
    
    y += titleSize.height;
    y += 5;
    
    // 三小图
    // 图一
    CGFloat imageWidth = (contentWidth - 5 * 2) / 3;
    ADCDN_NativeCustomRenderImage *image1 = [model.adImageAry firstObject];
    const CGFloat imageHeight = imageWidth * (image1.height / image1.width);
    CGFloat originX = padding.left;
    self.adImageView1 = [UIImageView new];
    self.adImageView1.frame = CGRectMake(originX, y, imageWidth, imageHeight);
    self.adImageView1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image1.imageURL]]];
    originX += (imageWidth + 5);
    
    // 图二
    ADCDN_NativeCustomRenderImage *image2 = model.adImageAry[1];
    self.adImageView2 = [UIImageView new];
    self.adImageView2.frame = CGRectMake(originX, y, imageWidth, imageHeight);
    self.adImageView2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image2.imageURL]]];
    originX += (imageWidth + 5);
    
    // 图三
    ADCDN_NativeCustomRenderImage *image3 = model.adImageAry[2];
    self.adImageView3 = [UIImageView new];
    self.adImageView3.frame = CGRectMake(originX, y, imageWidth, imageHeight);
    self.adImageView3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image3.imageURL]]];
    
    y += imageHeight;
    y += 10;
    
    // 副标题
    CGFloat maxInfoWidth = width - 2 * margin;
    self.adDescriptionLabel = [UILabel new];
    self.adDescriptionLabel.frame = CGRectMake(padding.left , y , maxInfoWidth, 20);
    self.adDescriptionLabel.attributedText = [ADCDN_StringStyleTool subtitleAttributeText:model.adDesc];
    
    [self.customView addSubview:self.adTitleLabel];
    [self.customView addSubview:self.adImageView1];
    [self.customView addSubview:self.adImageView2];
    [self.customView addSubview:self.adImageView3];
    [self.customView addSubview:self.adDescriptionLabel];
    
    // 设置customView的高度，相当于tableview列表中的cell.contentView,刷新cell的rowHeight
    CGFloat customViewHeigth = y + padding.bottom + self.adDescriptionLabel.frame.size.height;
    self.customView.frame = CGRectMake(0, 100, ScreenW, customViewHeigth);
       
}
#pragma mark - 单图(左图右文)
-(void)setUISmallModel:(ADCDN_NativeCustomRenderModel *)model{
    if (self.customView.superview) {
        [self.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    CGFloat width = ScreenW;
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    // 左图
    ADCDN_NativeCustomRenderImage *image = [model.adImageAry firstObject];
    const CGFloat imageWidth = (width - 2 * margin) / 3;
    const CGFloat imageHeight = imageWidth * (image.height / image.width);
    CGFloat imageX = width - margin - imageWidth;
    self.adImageView1 = [UIImageView new];
    self.adImageView1.frame = CGRectMake(imageX, y, imageWidth, imageHeight);
    self.adImageView1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageURL]]];

    // 标题
    CGFloat maxTitleWidth =  contentWidth - imageWidth - margin;
    NSAttributedString *attributedText = [ADCDN_StringStyleTool titleAttributeText:model.adTitle];
    CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(maxTitleWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
    self.adTitleLabel = [UILabel new];
    self.adTitleLabel.numberOfLines = 0;
    self.adTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.adTitleLabel.frame = CGRectMake(padding.left, y , maxTitleWidth, MIN(titleSize.height, imageHeight));
    self.adTitleLabel.attributedText = attributedText;
    
    y += imageHeight;
    y += 10;
    
    // 广告来源
    CGFloat maxInfoWidth = width - 2 * margin;
    self.adDescriptionLabel = [UILabel new];
    self.adDescriptionLabel.frame = CGRectMake(padding.left , y , maxInfoWidth, 20);
    self.adDescriptionLabel.attributedText = [ADCDN_StringStyleTool subtitleAttributeText:model.adDesc];
    
    [self.customView addSubview:self.adImageView1];
    [self.customView addSubview:self.adTitleLabel];
    [self.customView addSubview:self.adDescriptionLabel];
   
    // 设置customView的高度，相当于tableview列表中的cell.contentView,刷新cell的rowHeight
    CGFloat customViewHeigth = y + padding.bottom + self.adDescriptionLabel.frame.size.height;
    self.customView.frame = CGRectMake(0, 100, ScreenW, customViewHeigth);
}
#pragma mark - 视频
-(void)setUIVideoModel:(ADCDN_NativeCustomRenderModel *)model{
    if (self.customView.superview) {
         [self.customView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     }
     CGFloat width = ScreenW;
     CGFloat contentWidth = (width - 2 * margin);
     CGFloat y = padding.top;
     // 主标题
     NSAttributedString *attributedText = [ADCDN_StringStyleTool titleAttributeText:model.adTitle];
     CGSize titleSize = [attributedText boundingRectWithSize:CGSizeMake(contentWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0].size;
     self.adTitleLabel = [UILabel new];
     self.adTitleLabel.numberOfLines = 0;
     self.adTitleLabel.textAlignment = NSTextAlignmentLeft;
     self.adTitleLabel.frame = CGRectMake(padding.left, y , contentWidth, titleSize.height);
     self.adTitleLabel.attributedText = attributedText;
     
     y += titleSize.height;
     y += 5;
     // 视频图
     ADCDN_NativeCustomRenderImage *image = [model.adImageAry firstObject];
     const CGFloat imageHeight = contentWidth * (image.height / image.width);
     model.adVideoView.frame = CGRectMake(padding.left, y, contentWidth, imageHeight);
    
     y += imageHeight;
     y += 10;
    
     // 副标题
     CGFloat maxInfoWidth = width - 2 * margin;
     self.adDescriptionLabel = [UILabel new];
     self.adDescriptionLabel.frame = CGRectMake(padding.left , y , maxInfoWidth, 20);
     self.adDescriptionLabel.attributedText = [ADCDN_StringStyleTool subtitleAttributeText:model.adDesc];
     
     [self.customView addSubview:self.adTitleLabel];
     [self.customView addSubview:model.adVideoView];
     [self.customView addSubview:self.adDescriptionLabel];
     
     // 设置customView的高度，相当于tableview列表中的cell.contentView,刷新cell的rowHeight
     CGFloat customViewHeigth = y + padding.bottom + self.adDescriptionLabel.frame.size.height;
     self.customView.frame = CGRectMake(0, 100, ScreenW, customViewHeigth);
}
#pragma mark - loadAd
-(void)loadAd{
    ADCDN_NativeCustomRenderAdManager *nativeCustomAd = [ADCDN_NativeCustomRenderAdManager shareManagerWithAppId:kAppId plcId:self.plcId];
   nativeCustomAd.rootViewController = self;
   nativeCustomAd.delegate = self;
    nativeCustomAd.customView = self.customView;
   [nativeCustomAd loadAd];
}

#pragma mark - ADCDN_NativeCustomRenderAdManagerDelegate

/**
 *  拉取广告成功
 */
- (void)ADCDN_NativeCustomRenderAdSuccessToLoad:(ADCDN_NativeCustomRenderAdManager *)nativeExpressAd withAdDataModel:(ADCDN_NativeCustomRenderModel *)adDataModel{
    NSLog(@"拉取广告成功");
    // 渲染视图
//    [self buildupCustomView:adDataModel];
    
    // 大图
    if (adDataModel.imageMode == ADCDNFeedADModeLargeImage) {
        [self setUILargeModel:adDataModel];
    }
    // 组图
    if (adDataModel.imageMode == ADCDNFeedADModeGroupImage) {
        [self setUIGroupModel:adDataModel];
    }
    // 单图
    if (adDataModel.imageMode == ADCDNFeedADModeSmallImage) {
        [self setUISmallModel:adDataModel];
    }
    // 视频
    if (adDataModel.imageMode == ADCDNFeedVideoAdModeImage) {
        [self setUIVideoModel:adDataModel];
        
    }
    /**
     *   测试自渲染信息
     */
    NSLog(@"广告标题：%@",adDataModel.adTitle);
    NSLog(@"广告副标题：%@",adDataModel.adDesc);
    NSLog(@"广告来源：%@",adDataModel.source);
    NSLog(@"广告icon：%@",adDataModel.adIcon);
    NSLog(@"广告图：%@",[adDataModel.adImageAry firstObject].imageURL);
}
/**
 *  拉取广告失败
 */
- (void)ADCDN_NativeCustomRenderAd:(ADCDN_NativeCustomRenderAdManager *)nativeExpressAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"拉取广告失败");
}
/**
 *  点击广告
 */
- (void)ADCDN_NativeCustomRenderAdDidClick:(ADCDN_NativeCustomRenderAdManager *)nativeExpressAd{
    NSLog(@"点击广告");
}
/**
 *  曝光回调
 */
- (void)ADCDN_NativeCustomRenderAdDidBecomeVisible:(ADCDN_NativeCustomRenderAdManager *)nativeExpressAd{
    NSLog(@"曝光回调");
}
@end
