//
//  ComicGridViewCell.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/5/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "AQGridViewCell.h"

@class ComicItem;

@interface ComicGridViewCell : AQGridViewCell
{
    UIImageView *_imageView;
    UILabel *_title;
    UIButton *_volumnButton;
    UILabel *_date;
    UIActivityIndicatorView *_loadingView;
    ComicItem *_item;
}

@property (nonatomic, retain) ComicItem *item;
@property (nonatomic, readonly) UIButton *volumnButton;

@end
