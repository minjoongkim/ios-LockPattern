//
//  NormalCircle.h
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalCircle : UIView

@property (nonatomic) BOOL selected;
@property (nonatomic) CGContextRef cacheContext;

- (id)initwithRadius:(CGFloat)radius;

- (void)highlightCell;
- (void)resetCell;

@end
