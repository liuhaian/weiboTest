//
//  practiceTableViewController.m
//  weiboTest
//
//  Created by Haian Liu on 3/27/14.
//  Copyright (c) 2014 Haian Liu. All rights reserved.
//

#import "practiceTableViewController.h"


@interface practiceTableViewController ()

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [practiceWeiboInfo getInstance].controller=self;
    
    SinaWeibo *sinaweibo = [practiceWeiboInfo getInstance].weiboObj;
    [sinaweibo requestWithURL:@"statuses/home_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:[practiceWeiboInfo getInstance]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - practiceViewDelegate
- (void)nextMove
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    practiceWeiboInfo *pObj=[practiceWeiboInfo getInstance];
    NSDictionary *nsOBJRecord=[pObj.statuses objectAtIndex:(indexPath.row)];
    if(nsOBJRecord!=nil){
        //cell.textLabel.text=[nsOBJRecord objectForKey:@"text"];
        NSString *nsOBJKey=[NSString stringWithFormat:@"%d",indexPath.row];
        NSMutableDictionary *objImagesDic=pObj.authorProfileImages;
        if(objImagesDic==nil){
            objImagesDic=[NSMutableDictionary dictionaryWithCapacity:5];
            pObj.authorProfileImages=objImagesDic;
        }
        UIImage *objProfileImage = [objImagesDic objectForKey:nsOBJKey];
        if(objProfileImage==nil){
            NSString *url=nil;
            if(indexPath.row==1){
                url = @"http://ww3.sinaimg.cn/mw690/63475a73gw1ef8js7l7qmj20m80et0wh.jpg";
            }else{
                url = [[nsOBJRecord  objectForKey:@"user"] objectForKey:@"profile_image_url"];
            }
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
            objProfileImage=[UIImage imageWithData:imageData];
            if(objProfileImage!=nil){
                [objImagesDic setObject:objProfileImage forKey:nsOBJKey];
            }
        }
//        cell.imageView.image=objProfileImage;
        UIImageView *imgView;
        imgView = (UIImageView *)[cell viewWithTag:2];
        imgView.image=objProfileImage;
        
        imgView = (UIImageView *)[cell viewWithTag:3];
        imgView.image=objProfileImage;
        UILabel *txtLabel=(UILabel *)[cell viewWithTag:4];
        txtLabel.text=[nsOBJRecord objectForKey:@"text"];
    }
    // */
    
    
    
    
    return cell;
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

@end
