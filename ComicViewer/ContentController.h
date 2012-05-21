//
//  ContentController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentController : NSObject<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *_data;
    NSArray *_sortedKeys;
    UIView *_view;
}

@property (nonatomic, readonly)UIView *view;

- (id) initWithData:(NSDictionary *)data;

@end
