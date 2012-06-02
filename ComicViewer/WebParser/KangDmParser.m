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


#pragma mark Parser For Volumn

#define KEYTOTAL @"total"
#define KEYFORAMTSTRING @"formatstring"

inline static NSString* keyForURL(NSURL* url) {
	return [NSString stringWithFormat:@"KangDmParser-%u", [[url description] hash]];
}


@interface KangDmParser () 

- (void) parseUrl;

@end


@implementation KangDmParser



#pragma mark ctor/dtor

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


#pragma mark  internal Implementation function

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


#pragma mark functions for client


-(NSURL *) urlForIndex:(NSUInteger)index
{
    NSString *urlString = [[NSString stringWithFormat:_formatString, index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"index url: %@", url);
    
    return url;
}

@end


#pragma mark - Parser for Volumn List

@interface KangDmVolumnListParser()     

- (void) parseUrl;
- (void) parseContent: (NSString *) content error: (NSError **) error;

@end

@implementation KangDmVolumnListParser

@synthesize enc = _enc;

- (void) commonInit
{
    _enc = 0x80000632;
}

-(id) initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        _list = [[NSMutableArray alloc] init];
        _url = [url copy];
        [self parseUrl];
    }
    
    return self;
}


- (id) initWithString: (NSString *) string forUrl:(NSURL *)url error: (NSError **) error
{
    if (self = [super init]) {
        _list = [[NSMutableArray alloc] init];
        _url = [url copy];
        [self commonInit];
        [self parseContent:string error:error];
    }
    
    return self;
    
}

- (id) initwithData:(NSData *)data forUrl:(NSURL *)url error:(NSError **)error
{
    if (self = [super init]) {
        _url = [url copy];
        [self commonInit];
        _list = [[NSMutableArray alloc] init];
        NSString *content = [[NSString alloc] initWithData:data encoding:0x80000632];
        [self parseContent:content error:error];
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
    [self parseContent: html error:nil];
   
}

- (void) parseContent: (NSString *) content error: (NSError **) error
{
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:error];
    
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


#pragma mark - Parser for Comic

#define KANGDMURL @"http://www.kangdm.com"

@interface KangDmComicParser()     

- (void) parseUrl;
- (void) parseContent: (NSString *) content error: (NSError **) error;

@end



@implementation KangDmComicParser

@synthesize totalPages = _totalPages;

- (id) initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        _list = [[NSMutableArray alloc] init];
        _url = [url copy];
        _baseUrl = [[NSURL URLWithString:[KANGDMURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] retain];
        [self parseUrl];
    }
    
    return self;
}


- (void) dealloc
{
    [_url release];
    _url = nil;
    [_baseUrl release];
    _baseUrl = nil;
    [super dealloc];
}

#pragma mark internal implementation

- (void) parseUrl
{
    /*
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:_url]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSString *content = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        [self parseContent:content error:&error];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail to parse comic list for Url: %@ with Error: %@", [_url absoluteString], [error localizedDescription]);
    }];
    
    [[NSOperationQueue currentQueue] addOperation:request];
    [request release];
     */
    
    NSString *html = [NSString stringWithContentsOfURL:_url encoding:0x80000632 error:nil];
    [self parseContent: html error:nil];

    
     
}


- (void) parseContent:(NSString *)content error:(NSError **)error
{
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    HTMLNode *divComicNode = [bodyNode findChildWithAttribute:@"class" matchingName:@"main_left" allowPartial:NO];
    if (divComicNode) {
        NSArray *listNodes = [divComicNode findChildTags:@"li"];
        for (HTMLNode *listNode in listNodes) {
            
            HTMLNode *imageNode = [listNode findChildTag:@"img"];
            HTMLNode *comicNode = [[listNode findChildTag:@"h1"] findChildTag:@"a"];
            HTMLNode *volumnNode = [[listNode findChildTag:@"h2"] findChildTag:@"a"];
            HTMLNode *dateNode = [listNode findChildTag:@"font"];
            
            ComicItem *item = [[ComicItem alloc] init];
            
            NSString *image = [imageNode getAttributeNamed:@"src"];
            NSURL *imageUrl = [NSURL URLWithString:[image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            item.thumbnail = imageUrl;
            
            NSString *ref = [comicNode getAttributeNamed:@"href"];
            NSURL *itemUrl = [NSURL URLWithString:[[KANGDMURL stringByAppendingString:ref] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            item.url = itemUrl;
            
            NSString *title = [[comicNode firstChild] rawContents];
            item.title = title;
            
            NSString *volumn = [volumnNode getAttributeNamed:@"href"];
            NSURL *volumnUrl = [NSURL URLWithString:volumn relativeToURL:_baseUrl];
            item.newestVolumnUrl = volumnUrl;
            
            NSString *volumnTitle = [[volumnNode firstChild] rawContents];
            item.newestVolumn = volumnTitle;
            
            NSString *date = [[dateNode firstChild] rawContents];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromString = [dateFormatter dateFromString:date];
            item.updateDate = dateFromString;
            [dateFormatter release];
            
            [_list addObject:item];
            [item release];
            

        }
        
            
    }
    
    HTMLNode *divPageNode = [bodyNode findChildWithAttribute:@"class" matchingName:@"page" allowPartial:NO];
    if (divPageNode) {

        NSString *rawContents = [divPageNode rawContents];
        NSRange range = [rawContents rangeOfString:@"total_page="];
        NSRange divideRange = [[rawContents substringFromIndex:range.location] rangeOfString:@";"];
        NSRange statementRange = NSMakeRange(range.location, divideRange.location);
        NSString *statement = [rawContents substringWithRange:statementRange];
        NSString *pageString = [statement substringFromIndex:range.length];
        _totalPages = [pageString integerValue];
        
       // NSLog(@"statement: %@", statement);
       // NSLog(@"pages: %@", pageString);
    }   
    
    [parser release];

    
}


@end



