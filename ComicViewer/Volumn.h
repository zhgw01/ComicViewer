//
//  Volumn.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VolumnParser.h"

@protocol VolumnDelegate <NSObject>
@optional
-(void) updateImageAtIndex:(NSUInteger) index;
@end

@protocol VolumnLoaderObserver <NSObject>
@optional
-(void)imageDidLoad:(NSNotification*) notification;
-(void)imageDidFailToLoad:(NSNotification*) notification;
@end

@interface Volumn : NSObject
{
    NSURL *_url;
    NSUInteger _totalPages;
    NSMutableArray *_images;
    NSOperationQueue *_queue; //put in the view controller? It could be
    id<VolumnDelegate> _delegate;
    VolumnParser *_parser;
    BOOL _started;
}

@property (readonly) NSURL *url;
@property (readonly) NSUInteger totalPages;
@property (readonly) NSMutableArray* images;
@property (atomic, retain) id<VolumnDelegate> delegate;
@property (readonly) BOOL started;

-(id) initWithURL: (NSURL*) url;

//lazy downloading 
- (void) startDownloading;

@end
