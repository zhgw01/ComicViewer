//
//  CoverView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/19/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverView : UIScrollView
{
    
}

- (void) addTypeViewWithTitle:(NSString *) title data:(NSArray *) data delegate:(id<UITableViewDelegate>) delegate;

@end
