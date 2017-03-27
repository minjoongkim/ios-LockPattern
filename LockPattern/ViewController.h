//
//  ViewController.h
//  LockPattern
//
//  Created by 모바일보안팀 on 2017. 3. 15..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockScreen.h"

typedef enum {
    InfoStatusFirstTimeSetting = 0,
    InfoStatusConfirmSetting,
    InfoStatusFailedConfirm,
    InfoStatusNormal,
    InfoStatusFailedMatch,
    InfoStatusSuccessMatch
}	InfoStatus;

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet LockScreen *lockScreenView;
@property (nonatomic) InfoStatus infoLabelStatus;

@end

