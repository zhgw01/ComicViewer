//
//  ViewController.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/1/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ViewController.h"
#import "VolumnController.h"

#import "KangDmParser.h"

#import "UIImageView+AFNetworking.h"

#import "VolumnPhotoSource.h"
#import "EGOPhotoViewController.h"


#import "VolumnListController.h"
#import "ComicGridViewController.h"



@implementation ViewController
@synthesize newestView = _newestView;
@synthesize typeView = _typeView;
@synthesize alphabetView = _alphabetView;
@synthesize contentView = _contentView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //Initialize newest List
        for (int i = 1; i <= 6; ++i)
        {
            NSString *title = [NSString stringWithFormat:@"%d", i];
            
            NSURL *url;
            if (1 == i) {
                url = [NSURL URLWithString:@"http://www.kangdm.com/zuixinlianzai.html"];
            }
            else
            {
                NSString *urlString = [NSString stringWithFormat:@"http://www.kangdm.com/zuixinlianzai_%d.html",i];
                url = [NSURL URLWithString:urlString];
            }
            
            [dict setObject:url forKey:title];
        }
        
        //Initialize alphabet list
        for (char c = 'A'; c <= 'Z'; c++) {
            NSString *title = [NSString stringWithFormat:@"%c", c];
            NSString *urlString;

            if ('A' == c) {
                urlString = [NSString stringWithFormat:@"http://www.kangdm.com/list_%c.htm", tolower(c)];
            }
            else {
                urlString = [NSString stringWithFormat:@"http://www.kangdm.com/list_%c.htm", c];
            }
            NSURL *url = [NSURL URLWithString:urlString];
            
            [dict setObject:url forKey:title];
        }
        
        
        //Initialize type list
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_dzgd_1.htm"] 
                                      forKey:@"动作格斗"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_tyjj_1.htm"] 
                 forKey:@"体育竞技"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_snap_1.htm"] 
                 forKey:@"少女爱情"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_qsgx_1.htm"] 
                 forKey:@"轻松搞笑"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_lzjl_1.htm"] 
                 forKey:@"励志激励"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_kbgg_1.htm"] 
                 forKey:@"恐怖鬼怪"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_xyzt_1.htm"] 
                 forKey:@"悬疑侦探"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_khwl_1.htm"] 
                 forKey:@"科幻未来"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_yxtr_1.htm"] 
                 forKey:@"游戏同人"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_qcxy_1.htm"] 
                 forKey:@"青春校园"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_mhsh_1.htm"] 
                 forKey:@"魔幻神话"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_qhmx_1.htm"] 
                 forKey:@"奇幻冒险"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_shqg_1.htm"] 
                 forKey:@"生活情感"];
        [dict setObject:[NSURL URLWithString:@"http://www.kangdm.com/comic_qtfl_1.htm"] 
                 forKey:@"其它分类"];   
        
        _listSource = [dict copy];
        [dict release];
        
        
        //Create gridController
        _gridController = [[ComicGridViewController alloc] initWithNibName:nil bundle:nil];
        
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createNewestList
{
    for (int i = 1; i <= 6; ++i)
    {
        NSString *title = [NSString stringWithFormat:@"%d", i];
        [self.newestView addButtonWithTitle:title target:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }    
}

- (void)createTypeList
{
    NSArray *titles = [NSArray arrayWithObjects:@"动作格斗", 
                       @"体育竞技", 
                       @"少女爱情", 
                       @"轻松搞笑", 
                       @"励志激励", 
                       @"恐怖鬼怪", 
                       @"悬疑侦探", 
                       @"科幻未来", 
                       @"游戏同人", 
                       @"武侠历史", 
                       @"青春校园", 
                       @"魔幻神话", 
                       @"奇幻冒险", 
                       @"生活情感", 
                       @"其它分类", 
                       nil];
    for (NSString *title in titles) {
        [self.typeView addButtonWithTitle:title target:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)createAlphabetList
{
    for (char c = 'A'; c <= 'Z'; c++) {
        NSString *title = [NSString stringWithFormat:@"%c", c];
        [self.alphabetView addButtonWithTitle:title target:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self createNewestList];
    [self createTypeList];
    [self createAlphabetList];
    
    _gridController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridController.view.frame = self.contentView.bounds;
    CGSize size = self.contentView.bounds.size;
    self.contentView.contentSize = size;
    [self.contentView addSubview:_gridController.view];
    
}

- (void)viewDidUnload
{
    [self setTypeView:nil];
    [self setAlphabetView:nil];
    [self setNewestView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)clickButton:(UIButton *)sender {
    NSString *title = [sender currentTitle];
    NSURL *url = [_listSource valueForKey:title];
    
    NSLog(@"click for title: %@", title);
    [self.navigationController pushViewController:_gridController animated:YES];
    [_gridController setComicUrl:url];
}

-(void) viewBook
{

    /*
    VolumnController* controller = [[[VolumnController alloc] initWithUrl:[NSURL URLWithString:@"http://www.kangdm.com/comic/6553/tdsn-qyj/"]] autorelease];
    [self.view addSubview:controller.view];
    */
    
    /*
    KangDmParser *parser = [[KangDmParser alloc] initWithUrl:[NSURL URLWithString:@"http://www.kangdm.com/comic/6553/tdsn-qyj/index.js"]];
    NSLog(@"parser url: %@", parser.url);
    NSURL *url = [parser urlForIndex:1];
     */   
    
    /*
    VolumnPhotoSource *source = [[VolumnPhotoSource alloc] initWithVolumnURL:[NSURL URLWithString:@"http://www.kangdm.com/comic/7906/Q-and-A05j/"]];
    EGOPhotoViewController *photoConroller = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoConroller];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
    [photoConroller release];
    [source release];
     */
    
    /*
    VolumnListController *listController = [[VolumnListController alloc] initWithStyle:UITableViewStylePlain];
     listController.comicUrl = [NSURL URLWithString:@"http://www.kangdm.com/comic/8931/"];
    [self.view addSubview:listController.view];
    //[listController release];
    //should be deallocted somewhere, not here
     */
    
    
    /*
    ComicGridViewController *gridController = [[ComicGridViewController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:gridController.view];
    //gridController.comicUrl = [NSURL URLWithString:@"http://www.kangdm.com/zuixinlianzai_2.html"];
    [gridController performSelector:@selector(setComicUrl:) withObject:[NSURL URLWithString:@"http://www.kangdm.com/zuixinlianzai_2.html"] afterDelay:0.1];
    */
     
     ComicGridViewController *gridController = [[ComicGridViewController alloc] initWithNibName:nil bundle:nil];
    [gridController performSelector:@selector(setComicUrl:) withObject:[NSURL URLWithString:@"http://www.kangdm.com/zuixinlianzai_2.html"] afterDelay:0.1];
    
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gridController];
     navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     navController.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentModalViewController:navController animated:YES];

}

- (void)dealloc {
    [_listSource release];
    [_typeView release];
    [_alphabetView release];
    [_newestView release];
    [_contentView release];
    [super dealloc];
}
@end
