//
//  CoverView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/19/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "CoverView.h"
#import "TypeView.h"
#import "ContentController.h"

@interface CoverView()
- (void) fixDesiredCellSizeForWidth: (CGFloat) width;
- (void) fixRowPadding;
- (NSUInteger) numberOfItemsPerRow;
- (CGRect) cellRectAtIndex: (NSUInteger) index;
- (CGSize) entireSize;
-(void) didRotate:(NSNotification *) notification;
@end

@implementation CoverView

@synthesize topPadding=_topPadding, bottomPadding=_bottomPadding, leftPadding=_leftPadding, rightPadding=_rightPadding;

#define DEFAULT_CELL_SIZE CGSizeMake(300.0, 400.0);
#define DEFAULT_LEFT_PADDING 20
#define DEFAULT_RIGHT_PADDING 20
#define DEFAULT_TOP_PADDING 20
#define DEFAULT_BOTTOM_PADDING 20
#define DEFAULT_ROW_PADDING 30;

- (void) setup
{
    _desiredCellSize = DEFAULT_CELL_SIZE;
    _leftPadding = DEFAULT_LEFT_PADDING;
    _rightPadding = DEFAULT_RIGHT_PADDING;
    _topPadding = DEFAULT_TOP_PADDING;
    _bottomPadding = DEFAULT_BOTTOM_PADDING;
    _rowPadding = DEFAULT_ROW_PADDING;
    
    _typeviews = [[NSMutableArray alloc] init];
    _delegates = [[NSMutableArray alloc] init];
    
    self.backgroundColor = [UIColor clearColor];
    [self fixDesiredCellSizeForWidth:self.bounds.size.width];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didRotate:) 
                                                 name:@"UIDeviceOrientationDidChangeNotification" 
                                               object:nil];
    _sizeChanged = FALSE;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) dealloc
{
    [_typeviews release];
    _typeviews = nil;
    
    [_delegates release];
    _delegates = nil;
    
    [super dealloc];
}


- (void) addTypeViewWithTitle:(NSString *) title data:(NSDictionary *) data 
{
    NSUInteger index = [_typeviews count] + 1;
    CGRect rect = [self cellRectAtIndex:index];
    
    TypeView *type = [[TypeView alloc] initWithFrame:rect];
    [_typeviews addObject:type];
    
    type.headerLabel.text = title;
    
    ContentController *delegate = [[ContentController alloc] initWithData:data];
    delegate.view.frame = type.contentView.bounds;
    [type.contentView addSubview:delegate.view];
    
    [self addSubview:type];
    [type release];
    
    self.contentSize = [self entireSize];
}

- (void) setDesiredCellSize: (CGSize) desiredCellSize
{
    _desiredCellSize = desiredCellSize;
    [self setNeedsLayout];
}

- (CGSize) cellSize;
{
    return _actualCellSize;
}

- (void) fixDesiredCellSizeForWidth: (CGFloat) width
{
    CGFloat w = floorf(width - _leftPadding - _rightPadding);
	CGFloat dw = floorf(_desiredCellSize.width);
    CGFloat multiplier = floorf( w / dw );
    
    if (multiplier < 2) {
        _colPadding = 0.0;
    } else {
        _colPadding = ( w - dw * multiplier ) / (multiplier - 1);
    }
    
    _actualCellSize.width = (w + _colPadding) / multiplier - _colPadding;
	_actualCellSize.height = _desiredCellSize.height;
    
   // [self fixRowPadding];
}

- (void) fixRowPadding
{
    CGFloat multiplier = [self numberOfItemsPerRow];
    NSUInteger totalCols = floorf([_typeviews count] / multiplier);
    CGFloat residualHeight = self.bounds.size.height - _topPadding - totalCols * _actualCellSize.height;
    if (residualHeight >= 0) {
        if (totalCols > 1) {
            _rowPadding = residualHeight / (totalCols - 1);
        }
    }

    
}

- (NSUInteger) numberOfItemsPerRow
{
    return ( (NSUInteger)floorf(self.bounds.size.width / _actualCellSize.width) );
}

- (CGRect) cellRectAtIndex: (NSUInteger) index
{
	NSUInteger numPerRow = [self numberOfItemsPerRow];
    if ( numPerRow == 0 )       // avoid a divide-by-zero exception
        return ( CGRectZero );
	NSUInteger skipRows = index / numPerRow;
	NSUInteger skipCols = index % numPerRow;
	
	CGRect result = CGRectZero;
	result.origin.x = (_actualCellSize.width + _colPadding) * (CGFloat)skipCols + _leftPadding;
	result.origin.y = (_actualCellSize.height + _rowPadding) * (CGFloat)skipRows + _topPadding;
	result.size = _actualCellSize;
	
	return ( result );
}


- (CGSize) entireSize
{
    NSUInteger numPerRow = [self numberOfItemsPerRow];
    if ( numPerRow == 0 )       // avoid a divide-by-zero exception
        return ( CGSizeZero );
	NSUInteger numRows = [_typeviews count] / numPerRow;
	if ( [_typeviews count] % numPerRow != 0 )
		numRows++;
	
	CGFloat height = ( ((CGFloat)ceilf((CGFloat)numRows * (_actualCellSize.height + _rowPadding))) + _topPadding + _bottomPadding );
	if (height < self.bounds.size.height)
		height = self.bounds.size.height;
	
	return ( CGSizeMake(self.bounds.size.width, height) );
}

-(void) didRotate:(NSNotification *) notification
{
    _sizeChanged = TRUE;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    [self fixDesiredCellSizeForWidth:self.bounds.size.width];
    
    //self.contentSize = [self entireSize];
    if (_sizeChanged) {
        _sizeChanged = FALSE;
        self.contentSize = [self entireSize];
    }
    
    NSUInteger total = [_typeviews count];
    for (NSUInteger index = 0; index < total; ++index) {
        UIView *view = [_typeviews objectAtIndex:index];
        CGRect newFrame = [self cellRectAtIndex:index];
        view.frame = newFrame;
    }
    
    //Adjust the fit into the center
    if ([self entireSize].height == self.bounds.size.height) {
        UIView *view = [_typeviews lastObject];
        CGFloat maxY = view.frame.origin.y + view.frame.size.height;
        CGFloat adjustY = (_leftPadding + self.bounds.size.height - maxY) / 2.0 - _leftPadding;
        NSAssert(adjustY >= 0, @"adjust Y should be positive here");
        
        for (UIView *view in _typeviews) {
            CGRect newFrame = view.frame;
            newFrame.origin.y += adjustY;
            view.frame = newFrame;
        }
    }
    
}

@end
