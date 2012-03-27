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
- (NSString *) convertGB2312ToUTF8:(NSString *) content;

@end


@implementation KangDmParser

@synthesize totalPages = _totalPages;
@synthesize url = _url;

#pragma mark - ctor/dtor

- (id) initWithUrl:(NSURL *)url
{
    if ((self = [super init])) {
        _url = [url copy];
        [self parseUrl];
    }
    
    return self;
}

- (void) dealloc
{
    [_url release];
}

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
            NSLog(@"url: %@", _baseUrl);
        }
        
        if ([variable rangeOfString:@"tpf"].location != NSNotFound) {
            _tpf = [value intValue];
            NSLog(@"tpf: %d", _tpf);
        }
    }

    
    
}

- (NSString *) convertGB2312ToUTF8:(NSString *)content
{
    return nil;
}

- (void) parseScriptContent:(NSString *) content
{

    NSCharacterSet *endSet = [NSCharacterSet characterSetWithCharactersInString:@";\n"];
   
    NSArray *statements = [content componentsSeparatedByCharactersInSet:endSet];
    for (NSString *statment in statements) {
        [self parseStatement:statment];
    }
       
}

#pragma mark - internal Implementation function
- (void) parseUrl
{
    NSURL* url = [NSURL URLWithString:@"index.js" relativeToURL:_url];
    
    NSLog(@"url: %@", [url absoluteString]);
    
    /*
    
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"index.js"];
    NSLog(@"file: %@", path);
    
    NSOutputStream *file = [[NSOutputStream alloc] initToFileAtPath:path append:NO];
    request.outputStream = file;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *content = [[NSString alloc] initWithData:responseObject encoding:NSUTF16StringEncoding];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
        [self parseScriptContent:content];
        NSLog(@"content: %@", content);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
   
    [request start];
     */
    
    NSString *content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.txt"];
    [content writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"path: %@", path);
    [self parseScriptContent:content];
}


#pragma mark - functions for client

-(void) setUrl:(NSURL *)url
{
    _url = [url copy];
    [self parseUrl];
}


-(NSURL *) urlForIndex:(NSUInteger)index
{
    NSString *formatString = [NSString stringWithFormat:@"%@%%0%dd.jpg",_baseUrl, _tpf + 1];
    NSString *urlString = [[NSString stringWithFormat:formatString, index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"index url: %@", url);
    
    return url;
}

@end
