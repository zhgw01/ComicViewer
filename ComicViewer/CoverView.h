//
//  CoverView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/19/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"


@interface CoverView : UIScrollView
{
    CGFloat		_topPadding;
	CGFloat		_bottomPadding;
	CGFloat		_leftPadding;
	CGFloat		_rightPadding;
    
    NSMutableArray    *_typeviews;
    NSMutableArray    *_delegates;
    
    CGSize     _desiredCellSize;
    CGSize     _actualCellSize;
    CGFloat     _colPadding;
    CGFloat     _rowPadding;
    
    id<CoverViewDelegate> _coverviewDelegate;
    
@private
    BOOL    _sizeChanged;
}

@property (nonatomic) CGFloat topPadding, bottomPadding, leftPadding, rightPadding;
@property (nonatomic, retain) id<CoverViewDelegate> coverviewDelegate;

- (void) addTypeViewWithTitle:(NSString *) title data:(NSDictionary *) data;

- (void) setDesiredCellSize: (CGSize) desiredCellSize;
- (CGSize) cellSize;

@end
