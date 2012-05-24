//
//  CoverController.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "CoverController.h"
#import "CoverView.h"

@implementation CoverController

- (void) setupData
{
    NSMutableDictionary *tmpData = [[NSMutableDictionary alloc] init];
    
    //setup newest
    NSDictionary *newest = [[NSDictionary alloc] initWithObjectsAndKeys:@"http://www.kangdm.com/zuixinlianzai.html",@"最新", nil];
    [tmpData setObject:newest forKey:@"最新"];
    [newest release];
    
    //setup alphabeta
    NSMutableDictionary *alphabeta = [[NSMutableDictionary alloc] init];
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
        
        [alphabeta setObject:url forKey:title];
    }
    [tmpData setObject:alphabeta forKey:@"字母"];
    [alphabeta release];
    
    //setup type
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
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
    
    [tmpData setObject:dict forKey:@"类型"];
    [dict release];
    
    _data = [tmpData copy];
    [tmpData release];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comic-background.jpg"]];
    
    CoverView *cover = [[CoverView alloc] initWithFrame:self.view.bounds];
    cover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cover.coverviewDelegate = self;
    
    NSArray *titles = [_data allKeys];
    for (NSString *title in titles) {
        [cover addTypeViewWithTitle:title data:[_data objectForKey:title]];
    }
    
    [self.view addSubview:cover];
    [cover release];
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
    return YES;
}

-(void)selectUrl:(NSURL *)url title:(NSString *)title
{
    NSLog(@"select url: %@", url);
}


@end
