//
//  CellView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComicItem;

@interface CellView : UIView
{
    UIImageView *_contentView;
    
    UIImageView *_imageView;
    UILabel *_title;
    UIButton *_volumnButton;
    UILabel *_date;
    UIActivityIndicatorView *_loadingView;
    ComicItem *_item;
}

@property (nonatomic, retain) ComicItem *item;
@property (nonatomic, readonly) UIButton *volumnButton;


@property (nonatomic, retain) UIImageView *contentView;

@end
