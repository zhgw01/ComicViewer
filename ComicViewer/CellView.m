//
//  CellView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "CellView.h"
#import "UIImageView+AFNetworking.h"
#import "KangDmParser.h"
#import "VolumnListController.h"

#define DEFAULTIMAGEWIDTH 125
#define DEFAULTIMAGEHEIGHT 150


#define IMAGE_RATIO 0.79
#define TITLE_RATIO 0.08
#define BUTTON_RATIO 0.08
#define DATE_RATIO 0.05


@implementation CellView


@synthesize volumnButton = _volumnButton;
@synthesize item = _item;
@synthesize contentView = _contentView;
@synthesize shouldReverseForUrl = _shouldReverseForUrl;

- (void) initLabel: (UILabel *)label
{
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize: 12.0];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10.0;
    label.text = @"null";
    label.backgroundColor = [UIColor clearColor];
}

-(void) setupTest
{
    _imageView.image = [UIImage imageNamed:@"egopv_error_placeholder.png"];
    _title.text = @"Hello";
    _date.text = @"2012";
    [_volumnButton setTitle:@"Click" forState:UIControlStateNormal];
}

-(void) setup
{
    _contentView = [[UIImageView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_contentView];
    
    _imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    
    _title = [[UILabel alloc] initWithFrame: CGRectZero];
    [self initLabel:_title];
    
    _volumnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
   // _volumnButton.backgroundColor = [UIColor clearColor];
    [self initLabel:_volumnButton.titleLabel];
    
    _date = [[UILabel alloc] initWithFrame: CGRectZero];
    _date.textColor = [UIColor redColor];
    [self initLabel:_date];
    _date.backgroundColor = [UIColor whiteColor];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    self.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
    self.contentView.backgroundColor = self.backgroundColor;
  //  _imageView.backgroundColor = self.backgroundColor;
  //  _title.backgroundColor = self.backgroundColor;
   

    self.shouldReverseForUrl = NO;
    
    [self.contentView addSubview: _imageView];
    [self.contentView addSubview: _title];
    [self.contentView addSubview:_volumnButton];
    [self.contentView addSubview:_date];
    [self.contentView addSubview:_loadingView];
}

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self) {
       
        [self setup];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void) setItem:(ComicItem *)item
{
    [_item release];
    _item = [item retain];
    
    [_loadingView startAnimating];
    //!To fix
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
    
    [self layoutIfNeeded];
}


- (void) dealloc
{
    [_item release];
    _item = nil;
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
   
    
    [super dealloc];
}

#pragma mark - Properties

- (CGRect) imageFrame
{
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height * IMAGE_RATIO;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width == 0 ? DEFAULTIMAGEWIDTH : imageSize.width;
    CGFloat imageHeight = imageSize.height == 0 ? DEFAULTIMAGEHEIGHT : imageSize.height;
    
    if (imageWidth + 2 >= width) {
        imageWidth = width - 2;
    }
    
    if (imageHeight + 20 >= height) {
        imageHeight = height - 20;
    }
    
    CGFloat x = (width - imageWidth) / 2.0;
    CGFloat y = (height - imageHeight) / 2.0;
    
    return CGRectMake(x, y, imageWidth, imageHeight);
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = [self imageFrame];
    _loadingView.center = _imageView.center;
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    //setup title label frame
    CGRect frame = CGRectMake(0, contentHeight * IMAGE_RATIO, contentWidth, contentHeight * TITLE_RATIO);
    _title.frame = frame;
    
    //setup button frame
    frame = CGRectMake(0, frame.origin.y + frame.size.height, contentWidth, contentHeight * BUTTON_RATIO);
    _volumnButton.frame = frame;
    
    //setup date frame
    frame = CGRectMake(0, frame.origin.y + frame.size.height, contentWidth, contentHeight * DATE_RATIO);
    _date.frame = frame;
    
}

#pragma mark - Event Handling
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    VolumnListController *listController = [[VolumnListController alloc] initWithStyle:UITableViewStylePlain];
    listController.comicUrl = self.item.url;
    listController.reverse = self.shouldReverseForUrl;

    UINavigationController *navigationController = nil;
    
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *) self.window.rootViewController;
    }else {
        navigationController = self.window.rootViewController.navigationController;
    }
    
    [navigationController pushViewController:listController animated:YES];
}


@end
