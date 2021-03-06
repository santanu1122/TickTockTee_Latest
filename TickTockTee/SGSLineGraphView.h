//
//  SGSLineGraphView
//  
//
//  Created by PJ Gray on 12/9/12.
//  Copyright (c) 2012 Say Goodnight Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface SGSLineGraphViewComponent : NSObject


@property (nonatomic, assign) BOOL shouldLabelValues;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) UIColor *colour;

@property (nonatomic, copy) NSString *title, *labelFormat;
@property (nonatomic, strong) NSNumberFormatter* numberFormatter;

@end


@class UITapGestureRecognizer;
@interface SGSLineGraphView : UIView<UIGestureRecognizerDelegate>
 {
    CAShapeLayer* _linesPathLayer;
    CAShapeLayer* _pointsPathLayer;
    
    CALayer *layer;
    NSMutableArray *paths;
    UIView *popView;
    UILabel *disLabel;
     UILabel *labelX;
     NSString *iosVersion;
     UIGestureRecognizer *recognize;
     
}

@property (nonatomic, assign) float interval;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;

@property CGFloat hackValueIDontKnowYouFigureItOutIHateThisArg;
@property CGFloat sideMargin;

@property (nonatomic, strong) NSMutableArray *components, *xLabels, *HoverData;
@property (nonatomic, strong) UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;

@property (strong, nonatomic) NSString* yAxisLabelFormat;
@property (strong, nonatomic) NSNumberFormatter* yAxisFormatter;

@property (nonatomic, assign) NSUInteger numYIntervals; // Use n*5 for best results
@property (nonatomic, assign) NSUInteger numXIntervals;

- (void) setupGraphPaths;
- (void) startDrawingAnimation;
-(void)clearall;
@end
