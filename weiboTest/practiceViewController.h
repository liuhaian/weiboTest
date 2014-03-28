//
//  practiceViewController.h
//  weiboTest
//
//  Created by Haian Liu on 3/26/14.
//  Copyright (c) 2014 Haian Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "practiceWeiboInfo.h"

@protocol practiceViewDelegate;
@interface practiceViewController : UIViewController <practiceViewDelegate>

-(void)nextMove;

@end
