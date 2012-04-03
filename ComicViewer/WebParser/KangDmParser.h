//
//  KangDmParser.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VolumnParser.h"

@interface KangDmParser : VolumnParser
{
    NSString *_baseUrl;
    NSUInteger _tpf; 
    NSURL *_url; //the url to pass
    NSString *_formatString;
    NSMutableDictionary *_dictionary;
}


-(id) initWithUrl:(NSURL *) url;
- (NSURL *) urlForIndex: (NSUInteger) index;

@end




@interface KangDmVolumnListParser : VolumnListParser {
    
    NSURL *_url;
}

- (id) initWithUrl:(NSURL *) url;

@end