//
//  practiceWeiboInfo.h
//  weiboTest
//
//  Created by Haian Liu on 3/27/14.
//  Copyright (c) 2014 Haian Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
//#import "practiceViewController.h"

#define kAppKey             @"xxx"
#define kAppSecret          @"xxx"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"
#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif


@class SinaWeibo;
@class practiceViewController;
//Protocol
@protocol practiceViewDelegate <NSObject>

-(void)nextMove;

@end


@interface practiceWeiboInfo : NSObject <SinaWeiboDelegate, SinaWeiboRequestDelegate>{
    id<practiceViewDelegate> controller;
}

    @property (nonatomic, strong) SinaWeibo *weiboObj;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property (nonatomic, strong) NSArray *statuses;
    @property (nonatomic,strong) NSMutableDictionary *displayImagesDic;
    @property (nonatomic, strong) NSString *postStatusText;
    @property (nonatomic, strong) NSString *postImageStatusText;
//    @property (nonatomic, strong) practiceViewController *controller;
    @property(nonatomic,retain)id controller;

-(void)weiboObjInit;
-(void)login;
+(practiceWeiboInfo *)getInstance;

@end

