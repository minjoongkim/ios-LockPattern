//
//  Line.m
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "Line.h"

@implementation Line

- (id)initWithFromPoint:(CGPoint)A toPoint:(CGPoint)B AndIsFullLength:(BOOL)isFullLength;
{
    self.fromPoint = A;
    self.toPoint = B;
    self.isFullLength = isFullLength;
    return self;
}

@end
