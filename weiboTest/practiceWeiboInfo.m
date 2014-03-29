//
//  practiceWeiboInfo.m
//  weiboTest
//
//  Created by Haian Liu on 3/27/14.
//  Copyright (c) 2014 Haian Liu. All rights reserved.
//

#import "practiceWeiboInfo.h"

static practiceWeiboInfo * instance = nil;

@implementation practiceWeiboInfo

@synthesize weiboObj,userInfo,statuses,postStatusText,postImageStatusText,controller,authorProfileImages;

+(practiceWeiboInfo *)getInstance

{
    
    @synchronized(self) {
        
        if (instance == nil) {
            
            instance=[[self alloc] init];
        }
        
    }
    
    return instance;
    
}
-(void)weiboObjInit
{
    weiboObj = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:instance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        weiboObj.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        weiboObj.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        weiboObj.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }

}

-(void)login
{
    userInfo = nil;
     statuses = nil;
    
    SinaWeibo *sinaweibo = [self weiboObj];
    [sinaweibo logIn];
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    if(controller!=nil){
        //        [controller performSegue];
        [controller nextMove];
    }
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
//        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
//        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    
//    [self resetButtons];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
//        [userInfo release];
//        userInfo = [result retain];
        userInfo = result;
    }
    else if ([request.url hasSuffix:@"statuses/home_timeline.json"])
    {
//        [statuses release];
//        statuses = [[result objectForKey:@"statuses"] retain];
        statuses = [result objectForKey:@"statuses"];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
//        [alertView release];
        
 postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
//        [alertView release];
        postImageStatusText = nil;
    }
    
//    [self resetButtons];
    if(controller!=nil){
        //        [controller performSegue];
        [controller nextMove];
    }

}

@end
