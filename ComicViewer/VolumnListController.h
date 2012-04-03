//
//  VolumnListController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/1/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface VolumnListController : UITableViewController
{
    NSArray *_items;
    NSURL *_comicUrl; // the url to get volumn list
}

@property (nonatomic, retain) NSURL *comicUrl;

@end
