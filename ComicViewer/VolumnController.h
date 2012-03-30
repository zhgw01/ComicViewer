//
//  VolumnController.h
//  ComicViewer
//
//  Watch a Volumn
//
//  Created by Gongwei Zhang on 3/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Volumn.h"

@class ComicPageView;


@interface VolumnController : UIViewController<VolumnDelegate>
{
    Volumn *_vol;
    NSUInteger _currentPage;
    ComicPageView *_pageView;
    NSURL *_url;
}

-(id) initWithUrl:(NSURL *) url;

@property (retain) Volumn *vol;
@property (nonatomic) NSUInteger page;
@property (readonly) NSUInteger totalPages;
@property (retain) ComicPageView* pageView;

- (void) handleTap;

@end
