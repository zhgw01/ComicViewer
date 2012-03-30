//
//  VolumnPhotoSource.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/30/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "VolumnPhotoSource.h"
#import "KangDmParser.h"
#import "VolumnPhoto.h"

@implementation VolumnPhotoSource

@synthesize photos=_photos;
@synthesize numberOfPhotos=_numberOfPhotos;


- (id)initWithPhotos:(NSArray*)photos{
	
	if (self = [super init]) {
		
		_photos = [photos retain];
		_numberOfPhotos = [_photos count];
		
	}
	
	return self;
    
}

- (id)initWithVolumnURL:(NSURL *)url {
    if (self = [super init]) {
        
        KangDmParser *parser = [[[KangDmParser alloc] initWithUrl:url] autorelease];
        NSMutableArray *tempPhotos = [[[NSMutableArray alloc] init] autorelease];
        
        NSUInteger totalPages = parser.totalPages;
        for (NSUInteger i = 1; i <= totalPages; ++i) {
            NSURL *url = [parser urlForIndex:i];
            NSString *name = [NSString stringWithFormat:@"Page %d", i];
            VolumnPhoto *photo = [[VolumnPhoto alloc] initWithImageURL:url name:name];
            [tempPhotos addObject:photo];
            [photo release];
        }
        
        _photos = [tempPhotos retain];
        _numberOfPhotos = [_photos count];
    }
    
    return self;
}

- (id <EGOPhoto>)photoAtIndex:(NSInteger)index{
	
	return [_photos objectAtIndex:index];
	
}

- (void)dealloc{
	
	[_photos release], _photos=nil;
	[super dealloc];
}


@end
