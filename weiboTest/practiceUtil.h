//
//  practiceUtil.h
//  weiboTest
//
//  Created by labuser on 2014/04/27.
//  Copyright (c) 2014年 Haian Liu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface practiceUtil : NSObject

+(practiceUtil *)getInstance;
-(NSDictionary*)toJSON:(NSData *)data;
@end
