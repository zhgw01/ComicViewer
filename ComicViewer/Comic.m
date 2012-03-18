//
//  Comic.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/16/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "Comic.h"

@implementation Comic

@synthesize baseUrl = _baseUrl;
@synthesize allUrls = _allUrls;

-(id) initWithBaseUrl:(NSURL *)url
{
    if ((self = [super init])) {
        _baseUrl = url;
    }
    
    return self;
}

@end
