//
//  KangDmParser.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "KangDmParser.h"
#import "AFHTTPRequestOperation.h"
#import "EGOCache.h"
#import "HTMLParser.h"


#define KEYTOTAL @"total"
#define KEYFORAMTSTRING @"formatstring"


inline static NSString* keyForURL(NSURL* url) {
	return [NSString stringWithFormat:@"KangDmParser-%u", [[url description] hash]];
}


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
        _dictionary = [[NSMutableDictionary alloc] init];
        [self parseUrl];
    }
    
    return self;
}

- (void) dealloc
{
    [_url release];
    [_baseUrl release];
    [_dictionary release];
    [_formatString release];
    [super dealloc];
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
    if (nil == _url) {
        return;
    }
    
    NSDictionary *dict = [[EGOCache currentCache] dictionaryForKey:keyForURL(_url)];
    if (dict) {
        _totalPages = [[dict objectForKey:KEYTOTAL] integerValue];
        _formatString = [[dict objectForKey:KEYFORAMTSTRING] retain];
        
        return;
    }
    
    NSURL* url = [NSURL URLWithString:@"index.js" relativeToURL:_url];
    NSLog(@"parse url: %@", [url absoluteString]);
    
    NSError *error = nil;
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

    _formatString = [[NSString stringWithFormat:@"%@%%0%dd.jpg",_baseUrl, _tpf + 1] retain];
    
    //cache
    [_dictionary setObject:[NSNumber numberWithInteger:_totalPages] forKey:KEYTOTAL];
    [_dictionary setObject:_formatString forKey:KEYFORAMTSTRING]; 
    [[EGOCache currentCache] setDictionary:_dictionary forKey:keyForURL(_url)];
}


#pragma mark - functions for client


-(NSURL *) urlForIndex:(NSUInteger)index
{
    NSString *urlString = [[NSString stringWithFormat:_formatString, index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"index url: %@", url);
    
    return url;
}

@end


@interface KangDmVolumnListParser()     

- (void) parseUrl;

@end

@implementation KangDmVolumnListParser

-(id) initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        _list = [[NSMutableArray alloc] init];
        _url = [url copy];
        [self parseUrl];
    }
    
    return self;
}

- (void) dealloc
{
    [_url release];
    [super dealloc];
}


- (void) parseUrl
{
   
    
    NSString *html = [NSString stringWithContentsOfURL:_url encoding:0x80000632 error:nil];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    HTMLNode *divComicNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"comiczj" allowPartial:NO];
    if (divComicNode) {
        NSArray *listNodes = [divComicNode findChildTags:@"a"];
        for (HTMLNode *hrefNode in listNodes) {
            NSString *ref = [hrefNode getAttributeNamed:@"href"];
            NSString *title = [[hrefNode firstChild] rawContents];
            
            VolumnItem *item = [[VolumnItem alloc] init];
            NSURL *itemUrl = [NSURL URLWithString:ref relativeToURL:_url];
            item.url = itemUrl;
            item.title = title;
            
            [_list addObject:item];
            [item release];
        }
    }
    
       
    [parser release];
}

@end


