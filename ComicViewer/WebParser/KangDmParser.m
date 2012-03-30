//
//  KangDmParser.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "KangDmParser.h"
#import "AFHTTPRequestOperation.h"

@interface KangDmParser () 

- (void) parseUrl;

@end


@implementation KangDmParser



#pragma mark - ctor/dtor

- (id) initWithUrl:(NSURL *)url
{
    if ((self = [super init])) {
        _totalPages = 0;
        _tpf = 0;
        _url = [url copy];
        [self parseUrl];
    }
    
    return self;
}

- (void) dealloc
{
    [_url release];
    [_baseUrl release];
}


#pragma mark - internal Implementation function

- (void) parseStatement: (NSString *) statement
{

    NSArray *array = [statement componentsSeparatedByString:@"="];
    if ([array count] > 1) {
        NSString *variable = [array objectAtIndex:0];
        NSString *value = [array objectAtIndex:1];
        
        if ([variable rangeOfString:@"total"].location != NSNotFound) {
            _totalPages = [value intValue];
            NSLog(@"total: %d", _totalPages);
        }
        
        if ([variable rangeOfString:@"volpic"].location != NSNotFound) {
            NSString *path = [[value componentsSeparatedByString:@"'"] objectAtIndex:1];
            _baseUrl = [@"http://1.kangdm.com/comic_img/" stringByAppendingString:path];
            [_baseUrl retain];
            NSLog(@"url: %@", _baseUrl);
        }
        
        if ([variable rangeOfString:@"tpf"].location != NSNotFound) {
            _tpf = [value intValue];
            NSLog(@"tpf: %d", _tpf);
        }
    }

    
    
}


- (void) parseUrl
{
    NSURL* url = [NSURL URLWithString:@"index.js" relativeToURL:_url];
    NSLog(@"parse url: %@", [url absoluteString]);
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:&error];
    
    if (error) {
        NSLog(@"Invalid Url : %@ with Error: %@", [url absoluteString], [error localizedDescription]);
        return;
    }
    
    NSCharacterSet *endSet = [NSCharacterSet characterSetWithCharactersInString:@";\n"];
    
    NSArray *statements = [content componentsSeparatedByCharactersInSet:endSet];
    for (NSString *statment in statements) {
        [self parseStatement:statment];
    }

}


#pragma mark - functions for client


-(NSURL *) urlForIndex:(NSUInteger)index
{
    NSString *formatString = [NSString stringWithFormat:@"%@%%0%dd.jpg",_baseUrl, _tpf + 1];
    NSString *urlString = [[NSString stringWithFormat:formatString, index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"index url: %@", url);
    
    return url;
}

@end
