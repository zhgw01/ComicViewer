//
//  ComicPageView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/6/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ZoomView.h"


@interface ComicPageView : ZoomView
{
    
}

- (id) initWithTapTarget: (id)target action:(SEL) action;
- (void) displayImage: (UIImage*) anImage;

@end
