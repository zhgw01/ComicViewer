//
//  GridViewController.h
//  Nav
//
//  Created by Gongwei Zhang on 3/31/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface GridViewController : UIViewController<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    GMGridView *_gridView;
    UIPopoverController *_optionsPopOver;
    UINavigationController *_optionsNav;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
    NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
}

@end
