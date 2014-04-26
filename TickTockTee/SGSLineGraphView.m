//
//  SGSLineGraphView
//  
//
//  Created by PJ Gray on 12/9/12.
//  Copyright (c) 2012 Say Goodnight Software. All rights reserved.
//

#import "SGSLineGraphView.h"
#import <math.h>
#import <objc/runtime.h>
#define kAssociatedPlotObject @"kAssociatedPlotObject"
@implementation SGSLineGraphViewComponent

- (id)init
{
    self = [super init];
    if (self)
    {
        _labelFormat = @"%.1f%%";
       // layer=[CALayer layer];
    }
    
    return self;
    
}

@end

@implementation SGSLineGraphView
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.interval = 20;
		self.maxValue = 100;
		self.minValue = -300;
        self.hackValueIDontKnowYouFigureItOutIHateThisArg = -25;
		self.yLabelFont = [UIFont boldSystemFontOfSize:12];
		self.xLabelFont = [UIFont boldSystemFontOfSize:12];
		self.valueLabelFont = [UIFont boldSystemFontOfSize:10];
		self.legendFont = [UIFont boldSystemFontOfSize:10];
        self.numYIntervals = 5;
        self.numXIntervals = 1;
        self.sideMargin = 45;
    }
    //layer=self.layer;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.interval = 100;
		self.maxValue = 100;
		self.minValue = -300;
        self.hackValueIDontKnowYouFigureItOutIHateThisArg = -25;
		self.yLabelFont = [UIFont boldSystemFontOfSize:12];
		self.xLabelFont = [UIFont boldSystemFontOfSize:12];
		self.valueLabelFont = [UIFont boldSystemFontOfSize:10];
		self.legendFont = [UIFont boldSystemFontOfSize:10];
        self.numYIntervals = 5;
        self.numXIntervals = 1;
        self.sideMargin = 45;
    }
    //layer=[CALayer layer];
    return self;
}

- (NSString*) shortFormCurrencyWithNumber:(NSNumber*) number withFormatter:(NSNumberFormatter*) nformat {
    
    double doubleValue = [number doubleValue];
    
    if (doubleValue < 1000) {
        NSString* stringValue = [NSString stringWithFormat: @"%@", [nformat stringFromNumber:number] ];
        if ( [stringValue hasSuffix:@".00"] )
            stringValue = [stringValue substringWithRange: NSMakeRange(0, [stringValue length]-3)];
        return stringValue;
    }
    
    NSString *stringValue = nil;
    
    [nformat setMaximumFractionDigits:0];
    
    NSArray *abbrevations = [NSArray arrayWithObjects:@"k", @"m", @"b", @"t", nil] ;
    
    for (NSString *s in abbrevations)
    {
        doubleValue /= 1000.0 ;
        if ( doubleValue < 1000.0 )
        {
            if ( (long long)doubleValue % (long long) 100 == 0 ) {
                [nformat setMaximumFractionDigits:0];
            } else {
                [nformat setMaximumFractionDigits:2];
            }
            
            stringValue = [NSString stringWithFormat: @"%@", [nformat stringFromNumber: [NSNumber numberWithDouble: doubleValue]] ];
            NSUInteger stringLen = [stringValue length];
            
            if ( [stringValue hasSuffix:@".00"] )
            {
                // Remove suffix
                stringValue = [stringValue substringWithRange: NSMakeRange(0, stringLen-3)];
            } else if ( [stringValue hasSuffix:@".0"] ) {
                
                // Remove suffix
                stringValue = [stringValue substringWithRange: NSMakeRange(0, stringLen-2)];
                
            }
            
            // Add the letter suffix at the end of it
            stringValue = [stringValue stringByAppendingString: s];
           
            break ;
        }
    }
    
    return stringValue;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
 if(paths==NULL || paths==nil)
     paths=[[NSMutableArray alloc]init];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //save the state
    //CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    CGContextSetRGBFillColor(ctx, 0.8f, 0.8f, 0.8f, 0.8f);
    
    unsigned long n_div;
    float scale_min, scale_max, div_height;
    float top_margin = 35;
    float bottom_margin = 25;
	float x_label_height = 20;
	
    scale_min = self.minValue;
    scale_max = self.maxValue;
    
    n_div = self.numYIntervals+1;
    div_height =(self.frame.size.height-top_margin-bottom_margin-x_label_height)/(n_div-1);
    
//    // first loop thru and get the largest width of the y axis labels
//    CGFloat largestTextWidth = 0.0f;
//    for (int i=0; i<n_div; i++)
//    {
//        float y_axis = (self.interval*n_div) - i*self.interval;
//        NSString* formatString;
//        if (self.yAxisLabelFormat) {
//            formatString = self.yAxisLabelFormat;
//        } else {
//            formatString = @"%f";
//        }
//        
//        NSString *text = [NSString stringWithFormat:formatString, y_axis];
//        
//        CGSize textSize = [text sizeWithFont:self.yLabelFont];
//        if (largestTextWidth < textSize.width) {
//            largestTextWidth = textSize.width;
//        }
//    }
//    
//    if (self.sideMargin < largestTextWidth) {
//        self.sideMargin = largestTextWidth - 55.0f;
//    }

    // then loop thru and draw everything
    for (int i=0; i<n_div; i++)
    {
        float y_axis =(scale_max - i*self.interval);
        
        int y =(top_margin + div_height*i);
        
        NSString *text;
        text = [NSString stringWithFormat:@"%f", y_axis];
//        if (self.yAxisLabelFormat) {
//            text = [NSString stringWithFormat:self.yAxisLabelFormat, y_axis];
//        } else if (self.yAxisFormatter) {
//            text = [self shortFormCurrencyWithNumber:@(y_axis) withFormatter:self.yAxisFormatter];
//        } else {
//            text = [NSString stringWithFormat:@"%f", y_axis];
//        }
        NSArray *ArrayVal = [text componentsSeparatedByString:@".00"];
        text = [ArrayVal objectAtIndex:0];
        
        text=[NSString stringWithFormat:@"%.01f", [text floatValue]];
        
        //THIS parameter set the YLabel size and font
        CGSize textSize = [text sizeWithFont:self.yLabelFont];
        CGRect textFrame = CGRectMake(0,y-8,textSize.width,textSize.height);
//
//        [text drawInRect:textFrame
//				withFont:self.yLabelFont
//		   lineBreakMode:NSLineBreakByWordWrapping
//			   alignment:NSTextAlignmentRight];
//        
//        [paths addObject:[NSValue valueWithCGRect:textFrame]];
		
		
        
        labelX=[[UILabel alloc]initWithFrame:textFrame];
        
        labelX.font=[UIFont fontWithName:MYRIARDPROLIGHT size:12];
        labelX.backgroundColor=[UIColor clearColor];
        labelX.textColor=[UIColor whiteColor];
        labelX.text=text;
        [labelX sizeToFit];
        [self addSubview:labelX];
        NSLog(@"Text Of XLabel %@ ",text);
        // These are "grid" lines
        CGContextSetLineWidth(ctx, 1);
        
        CGContextSetRGBStrokeColor(ctx, 0.8f, 0.8f, 0.8f, 0.8f);
        CGContextMoveToPoint(ctx, self.sideMargin, y);
        
        // this 40 is the estimated width of the xvalue label
        CGContextAddLineToPoint(ctx, self.frame.size.width, y);
        CGContextStrokePath(ctx);
        
    }
        
    float margin = self.sideMargin + 5;
    float div_width;
    if ([self.xLabels count] == 1)
    {
        div_width = 0;
    }
    else
    {
        div_width = (self.frame.size.width-margin-30)/([self.xLabels count]-1);
    }
    
    // show the x label footer start
    
//    for (NSUInteger i=0; i<[self.xLabels count]; i++)
//    {
//        if (i % self.numXIntervals == 1 || self.numXIntervals==1) {
//            int x = (int) (margin + div_width * i);
//          
//            NSString *x_label = [NSString stringWithFormat:@"%@", [self.xLabels objectAtIndex:i]];
//            x_label= [x_label stringByReplacingOccurrencesOfString:@"'" withString:@""];
//            CGSize textSize = [x_label sizeWithFont:self.xLabelFont];
//            CGRect textFrame = CGRectMake(x-20, self.frame.size.height - x_label_height, textSize.width, x_label_height);
//            
//            [x_label drawInRect:textFrame withFont:self.xLabelFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
//            //UIBezierPath *path=[x_label accessibilityPath];
//           
//        };
//        
//    }
   // NSArray *views=[self subviews];
    //End of draw
   // CGContextRestoreGState(ctx);
    // show the x label footer end
    NSLog(@"This method called once again");
}

- (void) setupGraphPaths {
    
    //)iosVersion=@"ios4"; else iosVersion=@"ios5";
    unsigned long n_div;
    float scale_min, scale_max, div_height;
    float top_margin = 35;
    float bottom_margin = 25;
	float x_label_height = 20;
	
    scale_min = self.minValue;
    scale_max = self.maxValue;
    
    n_div = self.numYIntervals+1;
    div_height = (self.frame.size.height-top_margin-bottom_margin-x_label_height)/(n_div-1);

    float margin = self.sideMargin + 5;
    float div_width;
    if ([self.xLabels count] == 1)
    {
        div_width = 0;
    }
    else
    {
        div_width = (self.frame.size.width-margin-30)/([self.xLabels count]-1);
    }

    float circle_diameter = 5;
    float circle_stroke_width = 2;
    float line_width = 2;
    
    for (SGSLineGraphViewComponent *component in self.components)
    {
        UIBezierPath *linesPath = [UIBezierPath bezierPath];
        _linesPathLayer = [CAShapeLayer layer];
        _linesPathLayer.frame = self.frame;
        _linesPathLayer.strokeColor = [component.colour CGColor];
        _linesPathLayer.fillColor = [component.colour CGColor];
        _linesPathLayer.lineWidth = line_width;
        _linesPathLayer.opacity = 0.5;

        UIBezierPath *pointsPath = [UIBezierPath bezierPath];
        _pointsPathLayer = [CAShapeLayer layer];
        _pointsPathLayer.frame = self.frame;
        _pointsPathLayer.strokeColor = [component.colour CGColor];
        _pointsPathLayer.fillColor = [component.colour CGColor];
        _pointsPathLayer.lineWidth = circle_stroke_width;
        _pointsPathLayer.opacity = 0.7;
        
        int last_x = 0;
        int last_y = 0;
        BOOL firstPoint = YES;
        
        // Main Graph
        
		for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++)
        {
            id object = [component.points objectAtIndex:x_axis_index];
			
            if (object!=[NSNull null] && object)
            {
                float value = [object floatValue];
				
                int x = margin+div_width*x_axis_index;
                
                int y = (top_margin+self.hackValueIDontKnowYouFigureItOutIHateThisArg) + (scale_max-value)/self.interval*div_height;
                
                CGRect circleRect = CGRectMake(x-circle_diameter/2, y-circle_diameter/2, circle_diameter,circle_diameter);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y+25 + (circleRect.size.height / 2));
                //CGRect circleRectbtn = CGRectMake(x-circle_diameter/2, (y+20)-circle_diameter/2, circle_diameter,circle_diameter);
                // Overlay button start
                
                UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
                [bt setBackgroundColor:[UIColor whiteColor]];
                [bt setFrame:CGRectMake(0, 0, 10, 10)];
                [bt.layer setCornerRadius:12.0f];
                bt.layer.opacity = 0.7;
                [bt setCenter:circleCenter];
                [bt setTag:x_axis_index];
                [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:bt];
                
//               [pointsPath moveToPoint:CGPointMake(circleCenter.x+(circle_diameter/2), circleCenter.y)];
//             [pointsPath addArcWithCenter:circleCenter radius:circle_diameter/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
//                
                  // Overlay button end

                if (!firstPoint)
                {
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (circle_diameter/2) / distance * (x-last_x);
                    float last_y1 = last_y + (circle_diameter/2) / distance * (y-last_y);
                    float x1 = x - (circle_diameter/2) / distance * (x-last_x);
                    float y1 = y - (circle_diameter/2) / distance * (y-last_y);
                    
                        [linesPath moveToPoint:CGPointMake(last_x1, last_y1-5)];
                        [linesPath addLineToPoint:CGPointMake(x1, y1-5)];

                   //                    CGMutablePathRef backgroundPath = CGPathCreateMutable();
//                    CGPathMoveToPoint(backgroundPath, NULL, 200, y1);
                }
				
                firstPoint = NO;
                last_x = x;
                last_y = y;
            }
            
        }
        
        _pointsPathLayer.path = pointsPath.CGPath;
        _linesPathLayer.path = linesPath.CGPath;
        
        
        [self.layer addSublayer:_linesPathLayer];
        [self.layer addSublayer:_pointsPathLayer];
    }
}

- (void) startDrawingAnimation {
    [self.layer removeAllAnimations];
    
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.75;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [CATransaction setCompletionBlock:^{
        _pointsPathLayer.strokeEnd = 1.0f;
        _pointsPathLayer.fillColor = _pointsPathLayer.strokeColor;
        _linesPathLayer.strokeEnd = 1.0f;
    }];
    
    [_pointsPathLayer addAnimation:pathAnimation forKey:@"animateStrokeEnd"];
    [_linesPathLayer addAnimation:pathAnimation forKey:@"animateStrokeEnd"];
    [CATransaction commit];
}

-(void) clearall{   
    [_pointsPathLayer removeFromSuperlayer];
    [_linesPathLayer removeFromSuperlayer];
    //NSArray *array=[self subviews];
    for(UIView *viewx in self.subviews){
        if([viewx isKindOfClass:[UIButton class]])
        {
            [viewx removeFromSuperview];
        }
        if([viewx isKindOfClass:[UIView class]] || [viewx isKindOfClass:[UILabel class]])
        {
            NSLog(@"We are on label");
            [viewx removeFromSuperview];
        }
    }
   [self drawRect:self.frame];
    
}
- (void)btAction:(UIButton *)sender{
    //sender.tag
    [popView removeFromSuperview];
    
    //PopView
    popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [popView setBackgroundColor:[UIColor clearColor]];
    [popView setAlpha:0.0f];
    
    
    disLabel = [[UILabel alloc]initWithFrame:popView.frame];
    [disLabel setTextAlignment:NSTextAlignmentCenter];
    
    [popView addSubview:disLabel];
    [self addSubview:popView];
    
    disLabel.font=[UIFont fontWithName:MYRIARDPROLIGHT size:12];
    disLabel.textColor=[UIColor whiteColor];
    disLabel.backgroundColor=[UIColor clearColor];
    [disLabel setText:[[self.xLabels objectAtIndex:sender.tag]stringByReplacingOccurrencesOfString:@"'" withString:@""]];
    
    UIButton *bt = (UIButton*)sender;
    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    [popView setAlpha:1.0f];
//    recognize=[[UIGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//    
//    recognize.delegate=self;
//    //[recognize numberOfTouches:1];
//    [popView addGestureRecognizer:recognize];
//    [disLabel addGestureRecognizer:recognize];
//    [self addGestureRecognizer:recognize];
    
}
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gesture is heree");
  popView.hidden=YES;
    disLabel.hidden=YES;
}

@end
