//
//  WebParser.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Abstract Base Class, Parse a Volume or a Chaper of an Online Comic
 */
@interface WebParser : NSObject
{
    NSUInteger _totalPages;
}

@property (readonly) NSUInteger totalPages;

- (NSURL *) urlForIndex: (NSUInteger) index;

@end
