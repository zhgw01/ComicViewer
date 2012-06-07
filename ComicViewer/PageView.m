//
//  PageView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/28/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "PageView.h"
#import "CellView.h"
#import "KangDmParser.h"

@implementation PageView

#define DEFAULT_CELLSIZE CGSizeMake(152, 242)


@synthesize items = _items;
@synthesize cellSize = _cellSize;
@synthesize  shouldReverseForUrl = _shouldReverseForUrl;


- (void) setItems:(NSArray *)items
{
    if (items != _items) {
        
        NSUInteger itemCount = [items count];
        NSUInteger cellCount = [_cells count];
        NSUInteger index = 0;
        
        for (index = 0; index < itemCount; ++index) {
            CellView *cell = nil;
            if (index < cellCount) {
                cell = [_cells objectAtIndex:index];
                if (!cell.superview) {
                    cell.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
                    [self addSubview:cell];
                }
            } else {
                cell = [[CellView alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
                [self addSubview:cell];
                [_cells addObject:cell];
                [cell release]; 
            }
            
            cell.shouldReverseForUrl = self.shouldReverseForUrl;
            
            [cell setItem:[items objectAtIndex:index]];
        }
        
        while (index < cellCount) {
            [[_cells objectAtIndex:index] removeFromSuperview];
            ++index;
        }
        
        [_items release];
        _items = [items retain];
    }
       
}

-(NSUInteger) numbersPerRow
{
    return floor(self.bounds.size.width / self.cellSize.width);
}

-(NSUInteger) numbersPerColumn
{
    return floor(self.bounds.size.height / self.cellSize.height);
}

- (NSUInteger) cellsPerPage
{
    return [self numbersPerRow] * [self numbersPerColumn];
}

- (CGRect) rectAtIndex: (NSUInteger) index
{
    NSUInteger row = index / [self numbersPerRow];
    NSUInteger col = index % [self numbersPerRow];
    
    CGFloat width = self.bounds.size.width / [self numbersPerRow];
    CGFloat height = self.bounds.size.height / [self numbersPerColumn];
    CGFloat x = col * width;
    CGFloat y = row * height;
    CGRect outer = CGRectMake(x, y, width, height);
    
    CGFloat dx = (width - self.cellSize.width) / 2;
    CGFloat dy = (height - self.cellSize.height) / 2;
    if (dx < 0) {
        dx = 0;
    }
    if (dy < 0) {
        dy = 0;
    }
    
    return CGRectInset(outer, dx, dy);
}

- (void) layoutSubviews
{
    NSUInteger count = [self.subviews count];
    NSUInteger maxCells = [self cellsPerPage];
    NSUInteger index;
    
    NSUInteger indexCount = MIN(count, maxCells);
    
    for (index = 0; index < indexCount; ++index) {
        UIView *view = [self.subviews objectAtIndex:index];
        view.frame = [self rectAtIndex:index];
    }
    
    while (index < count) {
        UIView *view = [self.subviews objectAtIndex:index];
        view.frame = CGRectZero;
        ++index;
    }
    
}

-(void) setupTest
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int index = 0; index < 10; ++index) {
        ComicItem *item = [[ComicItem alloc] init];
        item.title = @"Test";
        item.thumbnail = [NSURL URLWithString:@"http://ww.kangdm.com/cimg/h6/%E5%AE%87%E5%AE%99%E6%96%B0%E5%A8%98.gif"];
        item.url = item.thumbnail;
        item.newestVolumn = @"newest";
        item.newestVolumnUrl = item.thumbnail;
        item.updateDate = [NSDate date];
        [array addObject:item];
        [item release];
    }
    
    self.items = array;
}

- (void) setup
{
    self.cellSize = DEFAULT_CELLSIZE;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comic-background.jpg"]];
    _cells = [[NSMutableArray alloc] init];
  //  [self setupTest];   
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
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
    [_cells release];
    
    
    [_items release];
    _items = nil;

    [super dealloc];
}

@end
