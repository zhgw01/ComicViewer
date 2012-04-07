//
//  ComicCell.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/7/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "AQGridViewCell.h"

@class ComicItem;

@interface ComicCell : AQGridViewCell
{
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_title;
    IBOutlet UIButton *_volumnButton;
    IBOutlet UILabel *_date;
    UIActivityIndicatorView *_loadingView;
    ComicItem *_item;
}

@property (nonatomic, retain) ComicItem *item;

+ (id)cell;

@end
