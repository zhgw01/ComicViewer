//
//  ListController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/29/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderPageControl.h"
#import "PageView.h"
#import "MBProgressHUD.h"

@interface ListController : UIViewController<UIScrollViewDelegate, SliderPageControlDelegate, MBProgressHUDDelegate>
{
    UIScrollView *_scrollView;
    SliderPageControl *_slider;
    NSInteger _currentPage;
    
    
    NSMutableArray *_items;
    NSUInteger _itemsPerPage;
    CGSize  _pageSize;
    NSUInteger _pages;
    NSURL *_url;
    
    MBProgressHUD *_hud;
    
@private
    //cache
    NSMutableDictionary *_pageDataCache;
}

-(id) initWithUrl:(NSURL *)url;

@end
