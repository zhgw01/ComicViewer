//
//  ViewController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/1/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"

@class VolumnController;
@class ComicGridViewController;

@interface ViewController : UIViewController
{
    VolumnController *_volController;
    NSDictionary *_listSource;
    ComicGridViewController *_gridController;
}

- (IBAction)clickButton:(UIButton *)sender;
-(void) viewBook;


@property (retain, nonatomic) IBOutlet CategoryView *newestView;
@property (retain, nonatomic) IBOutlet CategoryView *typeView;
@property (retain, nonatomic) IBOutlet CategoryView *alphabetView;
@property (retain, nonatomic) IBOutlet UIScrollView *contentView;

@end
