//
//  practiceUtil.m
//  weiboTest
//
//  Created by labuser on 2014/04/27.
//  Copyright (c) 2014年 Haian Liu. All rights reserved.
//

#import "practiceUtil.h"

static practiceUtil *instance = nil;

@implementation practiceUtil

+(practiceUtil *)getInstance

{
    
    @synchronized(self) {
        
        if (instance == nil) {
            
            instance=[[self alloc] init];
        }
        
    }
    
    return instance;
    
}


#pragma mark - Json
// 把当前的Dictionary对象,转成Json对象
-(NSDictionary*)toJSON:(NSData *)data{
    NSDictionary *deserializedDictionary=nil;
    NSString *jsonString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];     /* Now try to deserialize the JSON object into a dictionary */
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        NSLog(@"Successfully deserialized...");
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            deserializedDictionary = (NSDictionary *)jsonObject;
//            NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
            NSLog(@"Dersialized JSON Dictionary = %s", [[NSString stringWithFormat:@"%@",deserializedDictionary] UTF8String]);
            return deserializedDictionary;
        } else if ([jsonObject isKindOfClass:[NSArray class]]){
            NSArray *deserializedArray = (NSArray *)jsonObject;
            NSLog(@"Dersialized JSON Array = %@", deserializedArray);
        } else {
            NSLog(@"An error happened while deserializing the JSON data.");
        }
    }
    return deserializedDictionary;
}


@end
