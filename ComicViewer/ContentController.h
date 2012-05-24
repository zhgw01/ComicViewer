//
//  ContentController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoverViewDelegate<NSObject>
@optional
-(void)selectUrl:(NSURL *)url title:(NSString *)title;
@end


@interface ContentController : NSObject<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *_data;
    NSArray *_sortedKeys;
    UIView *_view;
    id<CoverViewDelegate> _delegate;
}

@property (nonatomic, readonly)UIView *view;
@property (nonatomic, retain) id<CoverViewDelegate> delegate;

- (id) initWithData:(NSDictionary *)data;

@end
