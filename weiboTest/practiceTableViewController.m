//
//  practiceTableViewController.m
//  weiboTest
//
//  Created by Haian Liu on 3/27/14.
//  Copyright (c) 2014 Haian Liu. All rights reserved.
//

#import "practiceTableViewController.h"
#import "practiceUtil.h"
#import "IconDownloader.h"


@interface practiceTableViewController ()

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation practiceTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title=@"微博搬运工";
//    [practiceWeiboInfo getInstance].controller=self;
//    
//    SinaWeibo *sinaweibo = [practiceWeiboInfo getInstance].weiboObj;
//    [sinaweibo requestWithURL:@"statuses/home_timeline.json"
//                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
//                   httpMethod:@"GET"
//                     delegate:[practiceWeiboInfo getInstance]];
    [self getFromURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getJsonFrom URL
- (void)getFromURL
{
    // Send a synchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pivotube.com/triplets/randomPics.php"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        // Parse data here
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newStr);
        NSDictionary* jsonObject = [[practiceUtil getInstance] toJSON:data];
        if(jsonObject!=nil){
            NSArray *picsArray=(NSArray*)[jsonObject objectForKey:@"groups"];
//            NSString *picURL_left=[(NSDictionary*)[picsArray objectAtIndex:0] objectForKey:@"pic_url"];
//            NSString *picURL_right=[(NSDictionary*)[picsArray objectAtIndex:1] objectForKey:@"pic_url"];
            practiceWeiboInfo *pObj=[practiceWeiboInfo getInstance];
//            NSLog(@"vote pic upload 2 Returned: %@", picURL_right);
            pObj.statuses=picsArray;
        }
    }
    
}

#pragma mark - practiceViewDelegate
- (void)nextMove
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([practiceWeiboInfo getInstance].statuses==nil){
        return 0;
    }
	NSUInteger count = [[practiceWeiboInfo getInstance].statuses count];
	
	// if there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return 20;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weiboCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // /*
    NSLog(@"display cell for row %d",indexPath.row);
    practiceWeiboInfo *pObj=[practiceWeiboInfo getInstance];
    NSDictionary *nsOBJRecord=[pObj.statuses objectAtIndex:(indexPath.row)];
    UILabel *txtLabelLeft=(UILabel *)[cell viewWithTag:4];
    UILabel *txtLabelRight=(UILabel *)[cell viewWithTag:5];
    UILabel *txtVoteCountLeft=(UILabel *)[cell viewWithTag:15];
    UILabel *txtVoteCountRight=(UILabel *)[cell viewWithTag:16];
    if(nsOBJRecord!=nil){
        //cell.textLabel.text=[nsOBJRecord objectForKey:@"text"];
        NSString *nsOBJKeyLeft=[NSString stringWithFormat:@"%d.l",indexPath.row];
        NSString *nsOBJKeyRight=[NSString stringWithFormat:@"%d.r",indexPath.row];
        //Set space to contain images.
        NSMutableDictionary *objImagesDic=pObj.displayImagesDic;
        if(objImagesDic==nil){
            objImagesDic=[NSMutableDictionary dictionaryWithCapacity:5];
            pObj.displayImagesDic=objImagesDic;
        }
        //Get Left Image
        UIImage *objProfileImageLeft = [objImagesDic objectForKey:nsOBJKeyLeft];
        if(objProfileImageLeft==nil){
            NSString *urlLeft=nil;
//Comment out the following as it is for Weibo
//            if(indexPath.row==1){
//                url = @"http://ww3.sinaimg.cn/mw690/63475a73gw1ef8js7l7qmj20m80et0wh.jpg";
//            }else{
//                url = [[nsOBJRecord  objectForKey:@"user"] objectForKey:@"profile_image_url"];
//            }

            //random pic start
            //The following is for data like "{"pid":"1","pic_url":"http://ww2.sinaimg.cn/mw690/7816cfd0jw1ee9yc70fj5j20er0m8wjh.jpg","author":"兎美酱Bunny"}
            NSDictionary* leftDic=[(NSArray*)[nsOBJRecord objectForKey:@"pics"] objectAtIndex:0];
            urlLeft = [leftDic objectForKey:@"pic_url"];
            txtLabelLeft.text=[leftDic objectForKey:@"author"];
            txtVoteCountLeft.text=[leftDic objectForKey:@"vote_count"];
            //randome pics end
//            
//            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlLeft]];
//            objProfileImageLeft=[UIImage imageWithData:imageData];
//            if(objProfileImageLeft!=nil){
//                [objImagesDic setObject:objProfileImageLeft forKey:nsOBJKeyLeft];
//            }
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:urlLeft forIndexPath:indexPath keyForImage:nsOBJKeyLeft];
            }

        }else{
            UIImageView *imgViewLeft = (UIImageView *)[cell viewWithTag:2];
            imgViewLeft.image=objProfileImageLeft;
            
        }
        
        //Get right Image
        UIImage *objProfileImageRight = [objImagesDic objectForKey:nsOBJKeyRight];
        if(objProfileImageRight==nil){
            NSString *urlRight=nil;
            //random pic start
            //The following is for data like "{"pid":"1","pic_url":"http://ww2.sinaimg.cn/mw690/7816cfd0jw1ee9yc70fj5j20er0m8wjh.jpg","author":"兎美酱Bunny"}
            NSDictionary* rightDic=[(NSArray*)[nsOBJRecord objectForKey:@"pics"] objectAtIndex:1];
            urlRight = [rightDic objectForKey:@"pic_url"];
            txtLabelRight.text=[rightDic objectForKey:@"author"];
            txtVoteCountRight.text=[rightDic objectForKey:@"vote_count"];
            //randome pics end
            
//            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlRight]];
//            objProfileImageRight=[UIImage imageWithData:imageData];
//            if(objProfileImageRight!=nil){
//                [objImagesDic setObject:objProfileImageRight forKey:nsOBJKeyRight];
//            }
            
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:urlRight forIndexPath:indexPath keyForImage:nsOBJKeyRight];
            }

        }else{
            UIImageView *imgViewRight = (UIImageView *)[cell viewWithTag:3];
            imgViewRight.image=objProfileImageRight;
        }
        
 
    }
    // */
    
    
    
    
    return cell;
}


- (IBAction)voteWithTag:(id)sender {
    NSLog(@"Left vote invoked!tag=%d",[sender tag]);
    UITableViewCell* tmpCell=nil;
    
    
    
    if ([[sender superview] isKindOfClass:[UITableViewCell class]]) {
        tmpCell=(UITableViewCell*)[sender superview];
    }else
        if ([[[sender superview] superview] isKindOfClass:[UITableViewCell class]]) {
            tmpCell=(UITableViewCell*)[[sender superview] superview];
        }else
            if([[[[sender superview] superview] superview] isKindOfClass:[UITableViewCell class]]){
                tmpCell=(UITableViewCell*)[[[sender superview] superview] superview];
            }
    //Get row from tap cell
    if(tmpCell!=nil){
        NSIndexPath *iPath=[self.tableView indexPathForCell:(UITableViewCell*)tmpCell];
        NSLog(@"MyRow:%d",iPath.row);
        //        sender.view.hidden=YES;
        //        [self.tableView reloadRowsAtIndexPaths:@[iPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iPath];
    }else{
        NSLog(@"table cell not found");
    }
    NSLog(@"Tag detected");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(NSString *)imageURLString forIndexPath:(NSIndexPath *)indexPath keyForImage:(NSString *)strKey
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:strKey];
    if (iconDownloader == nil)
    {
         iconDownloader = [[IconDownloader alloc] init];
        [iconDownloader setCompletionHandler:^(UIImage *img){
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            UIImage *imageRtn=img;
            
            // Display the newly loaded image
//            cell.imageView.image = appRecord.appIcon;
            NSString *nsOBJKeyLeft=[NSString stringWithFormat:@"%d.l",indexPath.row];
            NSString *nsOBJKeyRight=[NSString stringWithFormat:@"%d.r",indexPath.row];
            if([strKey isEqual:nsOBJKeyLeft]){
                if(img!=nil){
                    practiceWeiboInfo *pObj=[practiceWeiboInfo getInstance];
                    NSMutableDictionary *objImagesDic=pObj.displayImagesDic;
                    [objImagesDic setObject:img forKey:nsOBJKeyLeft];
                }
                UIImageView *imgViewLeft = (UIImageView *)[cell viewWithTag:2];
                imgViewLeft.image=img;
            }
            if([strKey isEqual:nsOBJKeyRight]){
                if(img!=nil){
                    practiceWeiboInfo *pObj=[practiceWeiboInfo getInstance];
                    NSMutableDictionary *objImagesDic=pObj.displayImagesDic;
                    [objImagesDic setObject:img forKey:nsOBJKeyRight];
                }
                UIImageView *imgViewRight = (UIImageView *)[cell viewWithTag:3];
                imgViewRight.image=img;
            }
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:strKey];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:strKey];
        [iconDownloader startDownload:imageURLString];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    practiceWeiboInfo *pObj=[practiceWeiboInfo getInstance];
    if ([pObj.statuses count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSDictionary *nsOBJRecord=[pObj.statuses objectAtIndex:(indexPath.row)];
            NSMutableDictionary *objImagesDic=pObj.displayImagesDic;
            NSString *nsOBJKeyLeft=[NSString stringWithFormat:@"%d.l",indexPath.row];
            NSString *nsOBJKeyRight=[NSString stringWithFormat:@"%d.r",indexPath.row];

            //Get Left Image
            UIImage *objProfileImageLeft = [objImagesDic objectForKey:nsOBJKeyLeft];
            if(objProfileImageLeft==nil){
                NSString *urlLeft=nil;
                NSDictionary* leftDic=[(NSArray*)[nsOBJRecord objectForKey:@"pics"] objectAtIndex:0];
                urlLeft = [leftDic objectForKey:@"pic_url"];

                 // Avoid the app icon download if the app already has an icon
                [self startIconDownload:urlLeft forIndexPath:indexPath keyForImage:nsOBJKeyLeft];
            }

            //Get Left Image
            UIImage *objProfileImageRight = [objImagesDic objectForKey:nsOBJKeyRight];
            if(objProfileImageRight==nil){
                NSString *urlRight=nil;
                NSDictionary* rightDic=[(NSArray*)[nsOBJRecord objectForKey:@"pics"] objectAtIndex:1];
                urlRight = [rightDic objectForKey:@"pic_url"];
                
                // Avoid the app icon download if the app already has an icon
                [self startIconDownload:urlRight forIndexPath:indexPath keyForImage:nsOBJKeyRight];
            }

        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


@end
