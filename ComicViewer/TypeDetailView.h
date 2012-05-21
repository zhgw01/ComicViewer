//
//  TypeDetailView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeDetailView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIButton *_button;
    NSArray *_data;
}

@property (nonatomic, retain) NSArray *data;

@end
