//
//  TypeView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/15/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "TypeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TypeView

@synthesize backgroundView = _backgroundView;
@synthesize titleView = _titleView;
@synthesize contentView = _contentView;
@synthesize headerLabel = _headerLabel;


#pragma mark - Initializer

#define DEFAULT_TITLE_HEIGHT 0.2f

- (void) setupLayer
{
    self.layer.cornerRadius = 20;
    self.layer.borderColor = [UIColor underPageBackgroundColor].CGColor;
    self.layer.borderWidth = 1.0;
    //it won't take effect when it
  /*
    self.layer.shadowOffset = CGSizeMake(10.0, 10.0);
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 2.5f;
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
   */
}


- (void) setup
{
    self.clipsToBounds = YES;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGRect titleRect = CGRectMake(0, 0, width, height * DEFAULT_TITLE_HEIGHT);
    _titleView = [[UIView alloc] initWithFrame:titleRect];
    [self addSubview:_titleView];
    
    UIImageView *background = [[[UIImageView alloc] initWithFrame:_titleView.bounds] autorelease];
    background.image = [UIImage imageNamed:@"header-bg.png"];
    [_titleView addSubview:background];
    
    self.headerLabel = [[[UILabel alloc] initWithFrame:_titleView.bounds] autorelease];
    self.headerLabel.font = [UIFont systemFontOfSize:32];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.shadowColor = [UIColor blackColor];
    self.headerLabel.shadowOffset = CGSizeMake(0, -1);
    self.headerLabel.textAlignment = UITextAlignmentCenter;
    self.headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.headerLabel.text = @"Title";
    [_titleView addSubview:self.headerLabel];

    CGRect contentRect = CGRectMake(0, titleRect.size.height, width, height - titleRect.size.height);
    _contentView = [[UIView alloc] initWithFrame:contentRect];
  //  _contentView.backgroundColor = [UIColor colorWithRed:246.0 / 255 green:1.0 blue:244.0 / 255.0 alpha:1.0f];
    [self addSubview:_contentView];
    
    [self setupLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return  self;
}

- (void) dealloc
{
    [_titleView release];
    _titleView = nil;
    [_contentView release];
    _contentView = nil;
    [_backgroundView release];
    _backgroundView = nil;
    
    [super dealloc];
}

#pragma mark - views
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGRect titleRect = CGRectMake(0, 0, width, height * DEFAULT_TITLE_HEIGHT);
    _titleView.frame = titleRect;
    
    CGRect contentRect = CGRectMake(0, titleRect.size.height, width, height - titleRect.size.height);
    _contentView.frame = contentRect;
}



#pragma mark - Properties

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_backgroundView atIndex:0];
    }
    
    return _backgroundView;
}


@end
