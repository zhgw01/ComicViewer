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
    NSStringEncoding _enc;
}

- (id) initWithUrl:(NSURL *) url;

-(id)initWithString:(NSString*)string forUrl:(NSURL *) url error:(NSError**)error;
-(id)initwithData:(NSData *)data forUrl:(NSURL *) url error:(NSError **)error;

@property (nonatomic) NSStringEncoding enc;

@end


@interface KangDmComicParser : ComicParser {
@private
    NSURL *_url;
    NSURL *_baseUrl;
    NSUInteger _totalPages;
}

- (id) initWithUrl: (NSURL *) url;

@property (nonatomic, readonly) NSUInteger totalPages;

@end