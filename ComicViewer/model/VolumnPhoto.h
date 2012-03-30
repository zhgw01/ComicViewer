//
//  VolumnPhoto.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/30/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOPhotoGlobal.h"

@interface VolumnPhoto : NSObject <EGOPhoto> {
    
	NSURL *_URL;
	NSString *_caption;
	CGSize _size;
	UIImage *_image;
	
	BOOL _failed;
	
}

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName image:(UIImage*)aImage;
- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName;
- (id)initWithImageURL:(NSURL*)aURL;
- (id)initWithImage:(UIImage*)aImage;

@end
