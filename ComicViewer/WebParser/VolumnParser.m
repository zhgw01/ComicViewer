//
//  WebParser.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "VolumnParser.h"


#pragma mark Parser for Volumn

@implementation VolumnParser

@synthesize totalPages = _totalPages;


- (NSURL *) urlForIndex: (NSUInteger) index
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end


#pragma mark - Parser for Volumn List 

//a comic can has many volumns, so you need to get the list of a comic

@implementation VolumnItem

@synthesize title = _title;
@synthesize url = _url;

- (void) dealloc
{
    self.title = nil;
    self.url = nil;
    
    [super dealloc];
}

@end


@implementation VolumnListParser

@synthesize list = _list;

- (void) dealloc
{
    [_list release];
    _list = nil;
}

@end


#pragma mark - Parser for Comic

@implementation ComicItem

@synthesize title = _title;
@synthesize thumbnail = _thumbnail;
@synthesize url = _url;
@synthesize newestVolumn = _newestVolumn;
@synthesize newestVolumnUrl = _newestVolunmnUrl;
@synthesize updateDate = _updateDate;

- (void) dealloc
{
    self.title = nil;
    self.url = nil;
    self.newestVolumn = nil;
    self.newestVolumnUrl = nil;
    self.updateDate = nil;
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"title:%@\nthumbnail:%@\nurl:%@\nVolumn:%@\nVolumn Url:%@\nUpdate Date:%@",
            _title, [_thumbnail absoluteString], [_url absoluteString],
            _newestVolumn, [_newestVolunmnUrl absoluteString], _updateDate];
}

@end


@implementation ComicParser

@synthesize list = _list;

-(NSURL *) getURlForTitle:(NSString *)title
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void) dealloc
{
    [_list release];
    _list = nil;
}


@end











