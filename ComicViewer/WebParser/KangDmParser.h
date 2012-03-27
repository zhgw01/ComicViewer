//
//  KangDmParser.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebParser.h"

@interface KangDmParser : WebParser
{
    NSString *_baseUrl;
    NSUInteger _tpf; 
    NSURL *_url; //the url to pass
}


-(id) initWithUrl:(NSURL *) url;
- (NSURL *) urlForIndex: (NSUInteger) index;


@end
