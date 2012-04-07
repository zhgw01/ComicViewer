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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
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

- (IBAction)clickButton:(id)sender {
    [self viewBook];
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

@end
