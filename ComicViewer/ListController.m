//
//  ListController.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/29/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ListController.h"
#import "KangDmParser.h"

@interface ListController()

-(void) parseUrl: (NSURL *) url;
-(void) appendDate:(NSArray *) data;
-(void) onPageChanged: (SliderPageControl *) sender;
-(void) onPageSizeChanged;
-(void) loadDataForPageView: (NSInteger) index;
-(NSArray *) dataForPage: (NSUInteger) index;
@end


@implementation ListController

@synthesize currentPage = _currentPage;

-(void) setup
{
    _itemsPerPage = 1;
    _currentPage = -1;
    _pages = 1;
    _pageSize = CGSizeZero;
    
    _items = [[NSMutableArray alloc] init];
    _pageDataCache = [[NSMutableDictionary alloc] init];
}

-(id) initWithUrl:(NSURL *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setup];
         _url = [url copy];
    }
    
    return self;
}


-(void) dealloc
{
    [_url release];
    _url = nil;
    [_items release];
    _items = nil;
    
    [_pageDataCache release];
    _pageDataCache = nil;
    
    
    [_scrollView release];
    _scrollView = nil;
    [_slider release];
    _slider = nil;
    [_hud release];
    _hud = nil;
    
    [super dealloc];
}
#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //setup scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.autoresizesSubviews = YES;
    [self.view addSubview:_scrollView];
   
    
    for (NSUInteger i = 1 ; i <= 3; ++i) {
        CGRect frame = _scrollView.bounds;
        frame.origin.x = (i - 1) * _pageSize.width;
        PageView *page = [[PageView alloc] initWithFrame:frame];
        page.tag = i;
        page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_scrollView addSubview:page];
        [page release];
    }
    
    //setup slider
    _slider = [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
    _slider.delegate = self;
    _slider.showsHint = YES;
    _slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    [_slider addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    //setup HUD
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.delegate = self;
    _hud.removeFromSuperViewOnHide = YES;
    _hud.labelText = @"Loading";
    //[_hud showWhileExecuting:@selector(parseUrl:) onTarget:self withObject:_url animated:YES];
    [self parseUrl:_url];
    
    //add Observer
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    if (!CGSizeEqualToSize(_pageSize, _scrollView.bounds.size)) {
        _pageSize = _scrollView.bounds.size;
        [self onPageSizeChanged];
    }
    */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - properties
- (void) setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * _currentPage;
        frame.origin.y = 0;
        [_scrollView scrollRectToVisible:frame animated:YES]; 

    }
}

#pragma mark - Notification

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"view.frame"]) {
        CGRect newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
        if (!CGSizeEqualToSize(_pageSize, newFrame.size)) {
            _pageSize = newFrame.size;
            [self onPageSizeChanged];
        }

    }
}


#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    const CGFloat currPos = _scrollView.contentOffset.x;
    const CGFloat pageWidth = _scrollView.bounds.size.width;
    const NSInteger selectedPage = lroundf(currPos / pageWidth);
       
    if (_currentPage == selectedPage) {
        return;
    }
   
    [self loadDataForPageView:selectedPage];
   
}

#pragma mark - SliderPageControlDelegate


#pragma mark - MBProgessHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

#pragma mark - Private method
-(void) parseUrl:(NSURL *)url
{
    //should only handle data here
    [_hud show:YES];
    KangDmComicParser *parser = [[KangDmComicParser alloc] initWithUrl:url];
    [_items addObjectsFromArray:parser.list];
    
    NSString *urlString = [url absoluteString];
    NSArray *lastComponent = [NSArray arrayWithObjects:@"_1.html", @"_1.htm", @".html", @".htm", nil];
    NSString *prefixUrl = nil;
    NSString *postfix = nil;
    
    
    for (NSString *component in lastComponent) {
        if ([urlString hasSuffix:component]) {
            NSRange range = [urlString rangeOfString:component options:NSBackwardsSearch];
            prefixUrl = [urlString substringToIndex:range.location];
            range = [component rangeOfString:@"."];
            postfix = [component substringFromIndex:range.location];
            break;
        }
    }
    
   // NSLog(@"Prefix Url: %@", prefixUrl);
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.navigationItem.rightBarButtonItem = barItem;
    [spinner release];
    [barItem release];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *comicItems = [[NSMutableArray alloc] initWithCapacity:300];
        NSUInteger total = parser.totalPages;
        for (NSUInteger i = 2; i <= total; ++i) {
            NSString *nextUrl = [NSString stringWithFormat:@"%@_%d%@", prefixUrl, i, postfix];
            NSURL *url = [NSURL URLWithString:nextUrl];
            ComicParser *comicParser = [[KangDmComicParser alloc] initWithUrl:url];
            [comicItems addObjectsFromArray:comicParser.list];
            [comicParser release];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self appendDate:comicItems]; 
            self.navigationItem.rightBarButtonItem = nil;
        });
        
        [comicItems release];
    });
    
    
    [parser release];
    [_hud hide:YES];
}

- (void) appendDate:(NSArray *)data
{
    //items for last page may be unfull, so we need to refresh it
    NSUInteger oldLastPageIndex = _items.count / _itemsPerPage;
    [_pageDataCache removeObjectForKey:[NSNumber numberWithUnsignedInteger:oldLastPageIndex]];

    
    [_items addObjectsFromArray:data];
    
    _pages = (_items.count + _itemsPerPage - 1) / _itemsPerPage;
    _scrollView.contentSize = CGSizeMake(_pageSize.width * _pages, _pageSize.height);
    [_slider setNumberOfPages:_pages];
    
    [self.view setNeedsDisplay];
}

- (NSArray *) dataForPage:(NSUInteger)index
{
    NSArray *result = nil;
    
    if (index < _pages) {
        
        result = [_pageDataCache objectForKey:[NSNumber numberWithUnsignedInteger:index]];
        if (!result) {
            NSRange range;
            range.location = index * _itemsPerPage;
            NSUInteger length = [_items count] - range.location;
            if (length > _itemsPerPage) {
                length = _itemsPerPage;
            }
            range.length = length;
            
            result = [_items subarrayWithRange:range];
            
            [_pageDataCache setObject:result forKey:[NSNumber numberWithUnsignedInteger:index]];
        }
        
    }

    return  result;
}

-(void) onPageChanged:(SliderPageControl *)sender
{
    int page = sender.currentPage;

    /*
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES]; 
     */
    
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * page, 0);
    [self loadDataForPageView:page];

    //self.currentPage = sender.currentPage;
    
}

-(void) onPageSizeChanged
{
    [_pageDataCache removeAllObjects];
    
    PageView *page = (PageView *)[_scrollView viewWithTag:1];
    NSUInteger oldItemsPerPage = _itemsPerPage;
    _itemsPerPage = page.cellsPerPage;
    _pages = (_items.count + _itemsPerPage - 1) / _itemsPerPage;
    _scrollView.contentSize = CGSizeMake(_pageSize.width * _pages, _pageSize.height);
    [_slider setNumberOfPages:_pages];
    
    //may also need adjust frame here
    
    if (_currentPage != -1) {
        //self.currentPage = (oldItemsPerPage * _currentPage) /_itemsPerPage;
        
        //It dosen't take effect for autorotate
        /*
        _currentPage = (oldItemsPerPage * _currentPage) /_itemsPerPage;
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * _currentPage;
        frame.origin.y = 0;
        [_scrollView scrollRectToVisible:frame animated:YES];
        [_slider setCurrentPage:_currentPage animated:YES];
         */
        _currentPage = (oldItemsPerPage * _currentPage) /_itemsPerPage;
        _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * _currentPage, 0);
        [self loadDataForPageView:_currentPage];
    } else {
     
        for (NSUInteger tag = 1; tag <= 3; ++tag) {
            UIView *view = [_scrollView viewWithTag:tag];
            CGRect frame = _scrollView.bounds;
            frame.origin.x = (tag - 1) * _pageSize.width;
            view.frame = frame;
        }
        
        [self loadDataForPageView:0];

    }
    
    [self.view setNeedsDisplay];
}

-(void) loadDataForPageView:(NSInteger)index
{
    const CGFloat pageWidth = _pageSize.width;
    const NSInteger zone = 1 + (index % 3);
    
    const NSInteger nextPage = index + 1;
    const NSInteger prevPage = index - 1;
    
        
    //next page
    if (nextPage < (NSInteger) _pages) {
        NSInteger nextViewTag = zone + 1;
        if (nextViewTag == 4) {
            nextViewTag = 1;
        }
        
        PageView *nextView = (PageView *)[_scrollView viewWithTag:nextViewTag];
        CGRect newFrame = nextView.frame;
        newFrame.origin.x = pageWidth * nextPage;
        nextView.frame = newFrame;
        nextView.items = [self dataForPage:nextPage];
    }
    
    //previous page
    if (prevPage >= 0) {
        NSInteger prevViewTag = zone - 1;
        if (0 == prevViewTag) {
            prevViewTag = 3;
        }
        
        PageView *prevView = (PageView *)[_scrollView viewWithTag:prevViewTag];
        CGRect newFrame = prevView.frame;
        newFrame.origin.x = pageWidth * prevPage;
        prevView.frame = newFrame;
        prevView.items = [self dataForPage:prevPage];
    }
    
    //current page
    if (0 <= index && index < _pages) {
        
        NSInteger currentViewTag = zone;
        PageView *currentView = (PageView *)[_scrollView viewWithTag:currentViewTag];
        CGRect newFrame = currentView.frame;
        newFrame.origin.x = pageWidth * index;
        currentView.frame = newFrame;
        currentView.items = [self dataForPage:index];
        
        _currentPage = index;
        [_slider setCurrentPage:_currentPage animated:NO];
    }

}

@end
