//
//  CategoryView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/24/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIScrollView
{
    CGFloat _xPosition;
    CGFloat _padding;
}

-(void) addButtonWithTitle: (NSString *)title target: (id)target action: (SEL) action forControlEvents:(UIControlEvents) controlEvents;

@property (nonatomic) CGFloat padding;

@end
