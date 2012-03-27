//
//  KangDmParser.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KangDmParser : NSObject
{
    NSURL *_url;
    NSUInteger _totalPages;
    NSString *_baseUrl;
    NSUInteger _tpf;
}

@property (readonly) NSUInteger totalPages;
@property (nonatomic, copy) NSURL *url;

-(id) initWithUrl:(NSURL *) url;
- (NSURL *) urlForIndex: (NSUInteger) index;


@end
