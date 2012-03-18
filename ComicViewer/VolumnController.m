//
//  VolumnController.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "VolumnController.h"
#import "Volumn.h"
#import "ComicPageView.h"

@implementation VolumnController

@synthesize vol = _vol;
@synthesize page = _currentPage;
@synthesize pageView = _pageView;
@dynamic totalPages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vol = [[Volumn alloc] initWithURL:[NSURL URLWithString:@"http://www.kangdm.com/comic/6553/tdsn-qyj/"]];
        _vol.delegate = self;
        _currentPage = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

 - (void) dealloc
{
    [_pageView release];
    [_vol release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageView = [[ComicPageView alloc] initWithTapTarget:self action:@selector(handleTap)];
    [self.view addSubview:_pageView];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicator];
}


- (void) viewWillAppear:(BOOL)animated
{
    [self setPage:_currentPage];
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Volumn Specific
- (NSUInteger) totalPages
{
    return _vol.totalPages;
}

- (void) setPage:(NSUInteger)page
{
    _currentPage = page;
    if (_currentPage <= _vol.totalPages) {
        [_pageView displayImage:[_vol.images objectAtIndex:_currentPage]];
    } else {
        [_indicator startAnimating];
    }
    /*
    else {
        NSLog(@"Out of Range: %d", _currentPage);
    }
     */

}

#pragma mark - Gesture Handler
- (void) handleTap
{
    _currentPage++;
    if (_currentPage < _vol.totalPages) {
        [_pageView displayImage:[_vol.images objectAtIndex:_currentPage]];
    }

}

#pragma mark - Volumn Delegate
-(void) updateImageAtIndex:(NSUInteger)index
{
    if (_currentPage == index) {
        [_indicator stopAnimating];
        [_pageView displayImage:[_vol.images objectAtIndex:_currentPage]];
    }
}


@end
