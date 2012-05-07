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
#import "VolumnListController.h"
#import "VolumnPhotoSource.h"
#import "EGOPhotoViewController.h"

@implementation ComicGridViewController

@synthesize gridView = _gridView;
@synthesize pageSlider = _pageSlider;
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
    [_items removeAllObjects];
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
    
    if (!_pageSlider) {
        _pageSlider =  [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
        [_pageSlider addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
        [_pageSlider setDelegate:self];
        [_pageSlider setShowsHint:YES];
        [self.view addSubview:_pageSlider];
        [_pageSlider setNumberOfPages:6];
        [_pageSlider setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

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
    self.gridView = nil;
    self.pageSlider = nil;
    [_items release];
    _items = nil;
    [super dealloc];
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
      //  [cell.volumnButton addTarget:self action:@selector(clickNewestVolumn:) forControlEvents:UIControlEventTouchUpInside];
      //  [cell.volumnButton setTag:index];
    }
    
    //Configure the cell
    //ToDo: when item change, and image not downloading well, crash
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
    ComicItem *item = [_items objectAtIndex:index];
    
    VolumnListController *listController = [[VolumnListController alloc] initWithStyle:UITableViewStylePlain];
    listController.comicUrl = item.url;
    
    [self.navigationController pushViewController:listController animated:YES];
   // [listController release];
}

- (void) clickNewestVolumn:(id)sender
{
    UIButton *button = sender;
    ComicItem *item = [_items objectAtIndex:button.tag];
    NSURL *url = item.newestVolumnUrl;
    VolumnPhotoSource *source = [[VolumnPhotoSource alloc] initWithVolumnURL:  url];
    EGOPhotoViewController *photoConroller = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoConroller];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
    [photoConroller release];
    [source release];

}

#pragma mark slider page control delegate
- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
	return @"GridView";
}

- (void)onPageChanged:(id)sender
{
    
}


@end
