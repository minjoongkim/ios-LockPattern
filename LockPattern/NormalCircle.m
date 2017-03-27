//
//  NormalCircle.m
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "NormalCircle.h"
#import <QuartzCore/QuartzCore.h>

#define kOuterColor			[UIColor brownColor] // 기본 가운대 바깥쪽
#define kInnerColor			[UIColor greenColor] // 기본 가운대
#define kHighlightColor     [UIColor yellowColor] // 선택 된 가운대
#define CircleImage         true

@implementation NormalCircle
@synthesize selected,cacheContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initwithRadius:(CGFloat)radius
{
    CGRect frame = CGRectMake(0, 0, 2*radius, 2*radius);
    NormalCircle *circle = [self initWithFrame:frame];
    if (circle) {
        [circle setBackgroundColor:[UIColor clearColor]];
    }
    
    return circle;
}

- (void)drawRect:(CGRect)rect
{
    if(CircleImage) {
        CGFloat lineWidth = 5.0;
        
        if(self.selected == NO) {
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
            [image setFrame:CGRectMake(rect.origin.x+lineWidth, rect.origin.y+lineWidth, rect.size.width-2*lineWidth, rect.size.height-2*lineWidth)];
            [self addSubview:image];
        }else {
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img2"]];
            [image setFrame:CGRectMake(rect.origin.x+lineWidth, rect.origin.y+lineWidth, rect.size.width-2*lineWidth, rect.size.height-2*lineWidth)];
            [self addSubview:image];
        }
    }else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        self.cacheContext = context;
        CGFloat lineWidth = 5.0;
        CGRect rectToDraw = CGRectMake(rect.origin.x+lineWidth, rect.origin.y+lineWidth, rect.size.width-2*lineWidth, rect.size.height-2*lineWidth);
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, kOuterColor.CGColor);
        CGContextStrokeEllipseInRect(context, rectToDraw);
        
        // Fill inner part
        CGRect innerRect = CGRectInset(rectToDraw,1, 1);
        CGContextSetFillColorWithColor(context, kInnerColor.CGColor);
        CGContextFillEllipseInRect(context, innerRect);
        
        if(self.selected == NO)
            return;
        
        // For selected View
        CGRect smallerRect = CGRectInset(rectToDraw,5, 5);
        CGContextSetFillColorWithColor(context, kHighlightColor.CGColor);
        CGContextFillEllipseInRect(context, smallerRect);

    }
    
}

- (void)highlightCell
{
    self.selected = YES;
    [self setNeedsDisplay];
}

- (void)resetCell
{
    self.selected = NO;
    [self setNeedsDisplay];
}


@end
