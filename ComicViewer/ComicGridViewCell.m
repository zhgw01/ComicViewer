//
//  ComicGridViewCell.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 4/5/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ComicGridViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "KangDmParser.h"

#define DEFAULTIMAGEWIDTH 125
#define DEFAULTIMAGEHEIGHT 150

@implementation ComicGridViewCell

@synthesize volumnButton = _volumnButton;
@synthesize item = _item;

- (void) initLabel: (UILabel *)label
{
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize: 12.0];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10.0;
    label.text = @"null";
}

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    _imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    
    _title = [[UILabel alloc] initWithFrame: CGRectZero];
    /*
    _title.highlightedTextColor = [UIColor whiteColor];
    _title.font = [UIFont boldSystemFontOfSize: 12.0];
    _title.adjustsFontSizeToFitWidth = YES;
    _title.minimumFontSize = 10.0;
    _title.text = @"null";
     */
    [self initLabel:_title];
    
    _volumnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [self initLabel:_volumnButton.titleLabel];
    
    _date = [[UILabel alloc] initWithFrame: CGRectZero];
    _date.textColor = [UIColor redColor];
    /*
    _date.textAlignment = UITextAlignmentCenter;
    _date.highlightedTextColor = [UIColor whiteColor];
    _date.font = [UIFont boldSystemFontOfSize: 12.0];
    _date.adjustsFontSizeToFitWidth = YES;
    _date.minimumFontSize = 10.0;
    _date.text = @"null";
     */
    [self initLabel:_date];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    
    self.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
    self.contentView.backgroundColor = self.backgroundColor;
    _imageView.backgroundColor = self.backgroundColor;
    _title.backgroundColor = self.backgroundColor;
    
    [self.contentView addSubview: _imageView];
    [self.contentView addSubview: _title];
    [self.contentView addSubview:_volumnButton];
    [self.contentView addSubview:_date];
    [self.contentView addSubview:_loadingView];
    
    return ( self );
}

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
    
    [self setNeedsLayout];
}


- (void) dealloc
{
    [_imageView release];
    _imageView = nil;
    [_title release];
    _title = nil;
    [_volumnButton release];
    _volumnButton = nil;
    [_date release];
    _date = nil;
    [_loadingView release];
    _loadingView = nil;
    [_item release];
    _item = nil;
    
    [super dealloc];
}

#pragma mark - Properties


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = _imageView.image.size;
    
    CGRect bounds = self.contentView.bounds;
    
    CGFloat imageWidth = imageSize.width == 0 ? DEFAULTIMAGEWIDTH : imageSize.width;
    CGFloat imageHeight = imageSize.height == 0 ? DEFAULTIMAGEHEIGHT : imageSize.height;
    CGFloat x = (self.bounds.size.width - imageWidth) / 2.0;
    CGFloat y = 10.0;
    _imageView.frame = CGRectMake(x, y, imageWidth, imageHeight);
    
    
    //CGRect bounds = CGRectInset( self.contentView.bounds, 10.0, 10.0 );
    /*
    [_title sizeToFit];
    CGRect frame = _title.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _title.frame = frame;
     */
    
    CGFloat currentY = CGRectGetMaxY(bounds);
    
    [_date sizeToFit];
    CGRect frame = _date.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = currentY - frame.size.height;
    currentY = frame.origin.y - 2;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _date.frame = frame;
    
    
    [_volumnButton.titleLabel sizeToFit];
    frame = _volumnButton.titleLabel.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = currentY - frame.size.height;
    currentY = frame.origin.y - 10;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _volumnButton.frame = frame;
    
    [_title sizeToFit];
    frame = _title.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = currentY - frame.size.height;
    currentY = frame.origin.y - 1;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _title.frame = frame;

    
    
    // adjust the frame down for the image layout calculation
    bounds.size.height = currentY - bounds.origin.y;
    
    if ( (imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MIN(hRatio, vRatio);
    
    [_imageView sizeToFit];
    frame = _imageView.frame;
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    _imageView.frame = frame;
}


@end
