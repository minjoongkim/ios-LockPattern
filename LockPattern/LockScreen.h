//
//  LockScreen.h
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LockScreen;

@protocol LockScreenDelegate <NSObject>

- (void)lockScreen:(LockScreen *)lockScreen didEndPattern:(NSNumber *)patternNumber;

@end

@interface LockScreen : UIView
@property (nonatomic, strong) id<LockScreenDelegate> delegate;
@property (nonatomic) BOOL allowClosedPattern;
@end
