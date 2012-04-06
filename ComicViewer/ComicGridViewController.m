//
//  ComicGridViewController.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/5/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ComicGridViewController.h"
#import "KangDmParser.h"
#import "ComicGridViewCell.h"

@implementation ComicGridViewController

@synthesize gridView = _gridView;
@synthesize comicUrl = _comicUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark getter and setter
- (void) setComicUrl:(NSURL *)comicUrl
{
    [_comicUrl release];
    _comicUrl = [comicUrl retain];
    
    [_loadingView startAnimating];
    ComicParser *parser = [[KangDmComicParser alloc] initWithUrl:_comicUrl];
    for (ComicItem *item in parser.list) {
        [_items addObject:item];
    }
    [parser release];
    [_loadingView stopAnimating];
    [_gridView reloadData];
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_gridView) {
        _gridView = [[AQGridView alloc] initWithFrame:self.view.bounds];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gridView.autoresizesSubviews = YES;
        _gridView.delegate = self;
        _gridView.dataSource = self;
    
        [self.view addSubview:_gridView];
    }
    
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:_loadingView];
        CGSize size = self.view.bounds.size;
        [_loadingView setCenter:CGPointMake(size.width / 2, size.height / 2)];
    }
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.gridView = nil;
    [_loadingView release];
    _loadingView = nil;
}


- (void) dealloc
{
   // self.gridView = nil;
    [_items release];
    _items = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}



#pragma mark - Grid View Data Source

- (NSUInteger) numberOfItemsInGridView:(AQGridView *)gridView
{
    return [_items count];
}

- (AQGridViewCell *) gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *cellIdentifier = @"GridViewCellIdentifier";
    
    ComicGridViewCell *cell = (ComicGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( cell == nil) {
        cell = [[[ComicGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 240.0) reuseIdentifier:cellIdentifier] autorelease];
    }
    
    //Configure the cell
    ComicItem *item = [_items objectAtIndex:index];
    cell.item = item;

    
    return cell;
}


- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    //Base on the orientation?
    return CGSizeMake(170.0, 260.0);
}

#pragma mark - Grid View Delegate

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    //pop the volumn list
}

@end
