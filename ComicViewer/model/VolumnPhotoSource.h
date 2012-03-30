//
//  VolumnPhotoSource.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/30/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOPhotoGlobal.h"

@interface VolumnPhotoSource : NSObject<EGOPhotoSource> {

    NSArray *_photos;
	NSInteger _numberOfPhotos;
    
}

- (id)initWithPhotos:(NSArray*)photos;

- (id)initWithVolumnURL: (NSURL*)url;

@end
