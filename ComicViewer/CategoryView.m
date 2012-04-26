//
//  CategoryView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/24/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView

@synthesize padding = _padding;

- (void) awakeFromNib
{
    _xPosition = 0;
    _padding = 5;
}

-(void) addButtonWithTitle: (NSString *)title target: (id)target action: (SEL) action forControlEvents:(UIControlEvents) controlEvents
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button sizeToFit];
    CGRect newFrame = button.frame;
    newFrame.origin.x = _xPosition;
    button.frame = newFrame;
    [self addSubview:button];
    
    _xPosition += button.frame.size.width + _padding;
    self.contentSize = CGSizeMake(_xPosition, self.frame.size.height);
}

@end
