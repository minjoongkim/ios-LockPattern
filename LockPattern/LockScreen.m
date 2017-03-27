//
//  LockScreen.m
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "LockScreen.h"
#import "NormalCircle.h"
#import "LockOverlay.h"


#define Tag1							1234
#define Tag2							4321



@interface LockScreen()
@property (nonatomic, strong) NormalCircle *selectedCell;
@property (nonatomic, strong) LockOverlay *overLay;
@property (nonatomic) NSInteger oldCellIndex,currentCellIndex;
@property (nonatomic, strong) NSMutableDictionary *drawnLines;
@property (nonatomic, strong) NSMutableArray *finalLines, *cellsInOrder;

@end

@implementation LockScreen
@synthesize delegate;
@synthesize selectedCell,overLay,oldCellIndex,currentCellIndex,drawnLines,finalLines,cellsInOrder, allowClosedPattern;



- (id)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    self = [super initWithFrame:frame];
    if (self) {
        [self setNeedsDisplay];
        [self setUpTheScreen];
        [self addGestureRecognizer];
    }
    return self;
}

- (void)setUpTheScreen{
    CGFloat radius = 30.0;
    CGFloat gap = (self.frame.size.width - 6 * radius )/4;
    CGFloat topOffset = radius;
    
    for (int i=0; i < 9; i++) {
        NormalCircle *circle = [[NormalCircle alloc]initwithRadius:radius];
        int column =  i % 3;
        int row    = i / 3;
        CGFloat x = (gap + radius) + (gap + 2*radius)*column;
        CGFloat y = (row * gap + row * 2 * radius) + topOffset;
        circle.center = CGPointMake(x, y);
        circle.tag = (row+1)*Tag1 + (column + 1);
        [self addSubview:circle];
    }
    self.drawnLines = [[NSMutableDictionary alloc]init];
    self.finalLines = [[NSMutableArray alloc]init];
    self.cellsInOrder = [[NSMutableArray alloc]init];
    // Add an overlay view
    self.overLay = [[LockOverlay alloc]initWithFrame:self.frame];
    [self.overLay setUserInteractionEnabled:NO];
    [self addSubview:self.overLay];
    // set selected cell indexes to be invalid
    self.currentCellIndex = -1;
    self.oldCellIndex = self.currentCellIndex;
}
#pragma - Gesture Handler

- (void)addGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestured:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestured:)];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:tap];
}

- (void)gestured:(UIGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    if([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
        if(gesture.state == UIGestureRecognizerStateEnded ) {
            if(self.finalLines.count > 0)[self endPattern];
            else [self resetScreen];
        }
        else [self handlePanAtPoint:point];
    }
    else {
        NSInteger cellPos = [self indexForPoint:point];
        self.oldCellIndex = self.currentCellIndex;
        if(cellPos >=0) {
            [self.cellsInOrder addObject:@(self.currentCellIndex)];
            [self performSelector:@selector(endPattern) withObject:nil afterDelay:0.3];
        }
    }
}

- (void)endPattern
{
    NSLog(@"PATTERN: %@",[self patternToUniqueId]);
    if ([self.delegate respondsToSelector:@selector(lockScreen:didEndPattern:)])
        [self.delegate lockScreen:self didEndPattern:[self patternToUniqueId]];
    
    [self resetScreen];
}

- (NSNumber *)patternToUniqueId
{
    long finalNumber = 0;
    long thisNum;
    for(int i = self.cellsInOrder.count - 1 ; i >= 0 ; i--){
        thisNum = ([[self.cellsInOrder objectAtIndex:i] integerValue] + 1) * pow(10, (self.cellsInOrder.count - i - 1));
        finalNumber = finalNumber + thisNum;
    }
    return @(finalNumber);
}

- (void)resetScreen
{
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[NormalCircle class]])
            [(NormalCircle *)view resetCell];
    }
    [self.finalLines removeAllObjects];
    [self.drawnLines removeAllObjects];
    [self.cellsInOrder removeAllObjects];
    [self.overLay.pointsToDraw removeAllObjects];
    [self.overLay setNeedsDisplay];
    self.oldCellIndex = -1;
    self.currentCellIndex = -1;
    self.selectedCell = nil;
}

- (void)handlePanAtPoint:(CGPoint)point
{
    self.oldCellIndex = self.currentCellIndex;
    NSInteger cellPos = [self indexForPoint:point];
    
    if(cellPos >=0 && cellPos != self.oldCellIndex) {
        long finalNumber = 0;
        long thisNum;
        for(int i = self.cellsInOrder.count - 1.0f ; i >= 0 ; i--){
            thisNum = ([[self.cellsInOrder objectAtIndex:i] integerValue] + 1) * pow(10, (self.cellsInOrder.count - i - 1));
            //현재의 선택된 셀과, 기존에 선택되었던 셀을 비교해서 중복되면 패스시킴.
            if((int)self.currentCellIndex+1 == (int) (thisNum / (int)pow(10, self.cellsInOrder.count - (i+1)))) {
                return;
            }
            finalNumber = finalNumber + thisNum;
        }

        [self.cellsInOrder addObject:@(self.currentCellIndex)];
    }
    if(cellPos < 0 && self.oldCellIndex < 0) return;
    
    else if(cellPos < 0) {
        Line *aLine = [[Line alloc]initWithFromPoint:[self cellAtIndex:self.oldCellIndex].center toPoint:point AndIsFullLength:NO];
        [self.overLay.pointsToDraw removeAllObjects];
        [self.overLay.pointsToDraw addObjectsFromArray:self.finalLines];
        [self.overLay.pointsToDraw addObject:aLine];
        [self.overLay setNeedsDisplay];
    }
    else if(cellPos >=0 && self.currentCellIndex == self.oldCellIndex) return;
    else if (cellPos >=0 && self.oldCellIndex == -1) return;
    else if(cellPos >= 0 && self.oldCellIndex != self.currentCellIndex)
    {
        // two situations: line already drawn, or not fully drawn yet
        NSNumber *uniqueId = [self uniqueLineIdForLineJoiningPoint:self.oldCellIndex AndPoint:self.currentCellIndex];
        
        if(![self.drawnLines objectForKey:uniqueId])
        {
            Line *aLine = [[Line alloc]initWithFromPoint:[self cellAtIndex:self.oldCellIndex].center toPoint:self.selectedCell.center AndIsFullLength:YES];
            [self.finalLines addObject:aLine];
            [self.overLay.pointsToDraw removeAllObjects];
            [self.overLay.pointsToDraw addObjectsFromArray:self.finalLines];
            [self.overLay setNeedsDisplay];
            [self.drawnLines setObject:@(YES) forKey:uniqueId];
        }
        else return;
    }
}
- (NSInteger )indexForPoint:(CGPoint)point
{
    for(UIView *view in self.subviews)
    {
        if([view isKindOfClass:[NormalCircle class]])
        {
            if(CGRectContainsPoint(view.frame, point)){
                NormalCircle *cell = (NormalCircle *)view;
                
                if(cell.selected == NO)	{
                    [cell highlightCell];
                    self.currentCellIndex = [self indexForCell:cell];
                    self.selectedCell = cell;
                }
                
                else if (cell.selected == YES && self.allowClosedPattern == YES) {
                    self.currentCellIndex = [self indexForCell:cell];
                    self.selectedCell = cell;
                }
                
                int row = view.tag/Tag1 - 1;
                int column = view.tag % Tag1 - 1;
                return row * 3 + column;
            }
        }
    }
    return -1;
}
- (NSInteger) indexForCell:(NormalCircle *)cell
{
    if([cell isKindOfClass:[NormalCircle class]] == NO || [cell.superview isEqual:self] == NO) return -1;
    else
        return (cell.tag/Tag1 - 1)*3 + (cell.tag % Tag1 - 1);
}
- (NormalCircle *)cellAtIndex:(NSInteger)index
{
    if(index<0 || index > 8) return nil;
    return (NormalCircle *)[self viewWithTag:((index/3+1)*Tag1 + index % 3 + 1)];
}
- (NSNumber *) uniqueLineIdForLineJoiningPoint:(NSInteger)point1 AndPoint:(NSInteger)point2
{
    return @(abs(point1+point2)*Tag1 + abs(point1-point2)*Tag2);
}
@end
