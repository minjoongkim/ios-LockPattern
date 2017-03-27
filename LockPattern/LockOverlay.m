//
//  LockOverlay.m
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "LockOverlay.h"

//#define kLineColor			[UIColor colorWithRed:245.0/255.0 green:128.0/255.0 blue:37.0/255.0 alpha:1.0]
//#define kLineGridColor  [UIColor colorWithRed:245.0/255.0 green:128.0/255.0 blue:37.0/255.0 alpha:1.0]
#define kLineColor			[UIColor redColor]
#define kLineGridColor  [UIColor blueColor]
#define CircleImage     true
@implementation LockOverlay

@synthesize pointsToDraw;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.pointsToDraw = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWidth = 5.0;
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, kLineColor.CGColor);
    for(Line *line in self.pointsToDraw)
    {
        CGContextMoveToPoint(context, line.fromPoint.x, line.fromPoint.y);
        CGContextAddLineToPoint(context, line.toPoint.x, line.toPoint.y);
        CGContextStrokePath(context);
        
        if(!CircleImage) {
            CGFloat nodeRadius = 20.0;
            
            CGRect fromBubbleFrame = CGRectMake(line.fromPoint.x- nodeRadius/2, line.fromPoint.y - nodeRadius/2, nodeRadius, nodeRadius);
            CGContextSetFillColorWithColor(context, kLineGridColor.CGColor);
            CGContextFillEllipseInRect(context, fromBubbleFrame);
            
            if(line.isFullLength){
                CGRect toBubbleFrame = CGRectMake(line.toPoint.x - nodeRadius/2, line.toPoint.y - nodeRadius/2, nodeRadius, nodeRadius);
                CGContextFillEllipseInRect(context, toBubbleFrame);
            }
        }
    }
}
@end
