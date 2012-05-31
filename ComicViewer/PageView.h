//
//  PageView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/28/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView
{
    NSMutableArray *_cells;
    NSArray *_items;
    
    CGSize _cellSize;
}

@property (nonatomic,retain) NSArray *items;
@property (nonatomic) CGSize cellSize;
@property (nonatomic, readonly) NSUInteger cellsPerPage;

@end
