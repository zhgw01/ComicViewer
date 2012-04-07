//
//  ComicCell.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/7/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ComicCell.h"
#import "KangDmParser.h"
#import "UIImageView+AFNetworking.h"

@implementation ComicCell

@synthesize item = _item;

- (void) setItem:(ComicItem *)item
{
    [_item release];
    _item = [item retain];
    
    [_loadingView startAnimating];
    [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:_item.thumbnail] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [_loadingView stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [_loadingView stopAnimating];
        _imageView.image = [UIImage imageNamed:@"egopv_error_placeholder.png"];
    }];
    
    _title.text = _item.title;
    _volumnButton.titleLabel.text = _item.newestVolumn;
    [_volumnButton setTitle:_item.newestVolumn forState:UIControlStateNormal];
    _date.text = [_item.updateDate description];
    
}

-(void)awakeFromNib
{
    _reuseIdentifier = @"GridViewCellIdentifier";
}


+ (id) cell
{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"ComicCell" owner:self options:nil];
    
    for (AQGridViewCell *cell in objs) {
        for (UIView *subview in cell.subviews) {
            [cell.contentView addSubview:subview];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionGlowColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.8 alpha:1.0];
        
        return cell;
    }
    
    return nil;
}

@end
