//
//  ComicGridViewController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/5/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface ComicGridViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate>
{
    AQGridView *_gridView;
    UIActivityIndicatorView *_loadingView;
    
    NSMutableArray *_items;
    NSURL *_comicUrl; // the url to get comic
}

@property (nonatomic, retain) AQGridView *gridView;
@property (nonatomic, retain) NSURL *comicUrl;

@end
