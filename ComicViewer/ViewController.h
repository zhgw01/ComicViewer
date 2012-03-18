//
//  ViewController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/1/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VolumnController;

@interface ViewController : UIViewController
{
    VolumnController *_volController;
}

- (IBAction)clickButton:(id)sender;
-(void) viewBook;


@end
