//
//  TypeView.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/15/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef UAMODALVIEW_DEBUG
#define UADebugLog( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define UADebugLog( s, ... ) 
#endif


@interface TypeView : UIView
{
    UIView *_backgroundView;
    UIView *_titleView;
    UIView *_contentView;
    UILabel *_headerLabel;
}

@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, readonly) UIView *titleView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, retain) UILabel *headerLabel;

@end
