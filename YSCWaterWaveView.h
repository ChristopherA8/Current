//
//  YSCWaterWaveView.h
//  AnimationLearn
//
//  Created by yushichao on 16/3/2.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSCWaterWaveAnimateType) {
    YSCWaterWaveAnimateTypeShow,
    YSCWaterWaveAnimateTypeHide,
    YSCWaterWaveAnimateTypeShrink,
};

@interface YSCWaterWaveView : UIView
 
@property (nonatomic, strong) UIColor *firstWaveColor;    // 第一个波浪颜色
@property (nonatomic, strong) UIColor *secondWaveColor;   // 第二个波浪颜色
@property (nonatomic, assign) CGFloat percent;            // 上升高度最大百分比

// Added by me :)
-(void)setUpWithWaveSpeed:(CGFloat)speed;
-(id)initWithFrame:(CGRect)frame waveSpeed:(CGFloat)speed startupSpeed:(CGFloat)startupSpeed waveAmplitudeMultiplier:(CGFloat)multiplier;
-(CGFloat)currentWavePointY;
-(void)setCurrentWavePointY:(CGFloat)wavePointY;

-(void) startWave;
-(void) stopWave;
-(void) reset;
- (void)removeFromParentView;

@end