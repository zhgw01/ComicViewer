//
//  WebParser.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "VolumnParser.h"

@implementation VolumnParser

@synthesize totalPages = _totalPages;


- (NSURL *) urlForIndex: (NSUInteger) index
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end


@implementation VolumnItem

@synthesize title = _title;
@synthesize url = _url;

@end


@implementation VolumnListParser

@synthesize list = _list;

- (void) dealloc
{
    [_list release];
    _list = nil;
}

@end