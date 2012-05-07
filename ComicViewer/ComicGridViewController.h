//
//  ComicGridViewController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/5/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "SliderPageControl.h"

@interface ComicGridViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, SliderPageControlDelegate>
{
    AQGridView *_gridView;
    UIActivityIndicatorView *_loadingView;
    SliderPageControl *_pageSlider;
    
    NSMutableArray *_items;
    NSURL *_comicUrl; // the url to get comic
}

@property (nonatomic, retain) AQGridView *gridView;
@property (nonatomic, retain) SliderPageControl *pageSlider;
@property (nonatomic, retain) NSURL *comicUrl;

- (void) clickNewestVolumn: (id) sender;

- (void)onPageChanged:(id)sender;

@end
