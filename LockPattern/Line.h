//
//  Line.h
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>


@interface Line : NSObject
@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) CGPoint toPoint;
@property (nonatomic) BOOL    isFullLength;		// boolean to indicate if the line is a full edge or a partial edge

- (id)initWithFromPoint:(CGPoint)A toPoint:(CGPoint)B AndIsFullLength:(BOOL)isFullLength;

@end

