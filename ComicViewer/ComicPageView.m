//
//  ComicPageView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/6/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ComicPageView.h"


@implementation ComicPageView

- (id) initWithTapTarget:(id)target action:(SEL)action
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ((self = [super initWithFrame:frame])) {
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.backgroundColor = [UIColor whiteColor];
               
        
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [recognizer requireGestureRecognizerToFail:[[self gestureRecognizers] lastObject]];
        [self addGestureRecognizer:recognizer];
        [recognizer release];
    }
    
    return self;
}

- (void) displayImage:(UIImage *)anImage
{
    if (anImage) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:anImage];
        [self setDisplayView:imageView];
        [imageView release];
    } else {
        [self setDisplayView:nil];
    }
}


@end
