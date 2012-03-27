//
//  WebParser.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "WebParser.h"

@implementation WebParser

@synthesize totalPages = _totalPages;


- (NSURL *) urlForIndex: (NSUInteger) index
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
