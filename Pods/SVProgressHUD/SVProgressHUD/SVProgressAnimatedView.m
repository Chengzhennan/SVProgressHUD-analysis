//
//  SVProgressAnimatedView.m
//  SVProgressHUD, https://github.com/SVProgressHUD/SVProgressHUD
//
//  Copyright (c) 2016 Tobias Tiemerding. All rights reserved.
//

#import "SVProgressAnimatedView.h"

@interface SVProgressAnimatedView ()

@property (nonatomic, strong) CAShapeLayer *ringAnimatedLayer;

@end

@implementation SVProgressAnimatedView

- (void)willMoveToSuperview:(UIView*)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    } else {
        //如果自己被从父控件中移除, 那么newSuperview 就是nil
        [_ringAnimatedLayer removeFromSuperlayer];
        _ringAnimatedLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.ringAnimatedLayer;
    [self.layer addSublayer:layer];
    
    CGFloat widthDiff = CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds);
    CGFloat heightDiff = CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds);
    layer.position = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2 - widthDiff / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2 - heightDiff / 2);
}

- (CAShapeLayer*)ringAnimatedLayer {
    if(!_ringAnimatedLayer) {
        CGPoint arcCenter = CGPointMake(self.radius+self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        
        //从Y 的正半轴开始 转回到这里
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.radius startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat) (M_PI + M_PI_2) clockwise:YES];
        
        _ringAnimatedLayer = [CAShapeLayer layer];
        //设置图层比例和屏幕的比例一致
        _ringAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _ringAnimatedLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        _ringAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
        _ringAnimatedLayer.strokeColor = self.strokeColor.CGColor;
        _ringAnimatedLayer.lineWidth = self.strokeThickness;
        _ringAnimatedLayer.lineCap = kCALineCapRound;
        _ringAnimatedLayer.lineJoin = kCALineJoinBevel;
        _ringAnimatedLayer.path = smoothedPath.CGPath;
    }
    return _ringAnimatedLayer;
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        
        if(self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setRadius:(CGFloat)radius {
    if(radius != _radius) {
        _radius = radius;
        
        //重新设置radius后 要先移除
        //因为,加入第一次 show 是默认的18pt radius, 点击另一按钮需要变成30pt, 那么要先移除18pt 那个 view, 再画上新的30的 view,
        [_ringAnimatedLayer removeFromSuperlayer];
        _ringAnimatedLayer = nil;
        
        //确保两个 ringView 都已经被加在了父控件上,再重新绘制,否则则不用
        if(self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setStrokeColor:(UIColor*)strokeColor {
    _strokeColor = strokeColor;
    _ringAnimatedLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeThickness:(CGFloat)strokeThickness {
    _strokeThickness = strokeThickness;
    _ringAnimatedLayer.lineWidth = _strokeThickness;
}

- (void)setStrokeEnd:(CGFloat)strokeEnd {
    _strokeEnd = strokeEnd;
    _ringAnimatedLayer.strokeEnd = _strokeEnd;
}

//size to fit  调用sizeThatFits 方法
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius+self.strokeThickness/2+5)*2, (self.radius+self.strokeThickness/2+5)*2);
}

@end
