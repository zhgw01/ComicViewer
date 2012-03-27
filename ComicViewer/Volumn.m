//
//  Volumn.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "Volumn.h"
#import "GDataXMLNode.h"
#import "AFHTTPRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "KangDmParser.h"

@interface Volumn()
-(void) startWithURL: (NSURL *)url;
-(void) parseHTML: (NSData *) data;
-(void) addImage: (UIImage *) image;
@end


@implementation Volumn

@synthesize url = _url;
@synthesize totalPages = _totalPages;
@synthesize images = _images;
@synthesize delegate = _delegate;

-(id) initWithURL:(NSURL *)url
{
    if ((self = [super init])) {
        _url = url;
        _images = [[NSMutableArray alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:8];
        [self startWithURL:url];
    }
    
    return self;
}

-(void) dealloc
{
    [_queue release];
    [_images release];
    [_delegate release];
}

#pragma mark - Images Downloading

-(void) startWithURL: (NSURL *)url
{
    /*
    AFHTTPRequestOperation* request = [[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]] autorelease];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"index.html"];
    NSLog(@"%@", path);
    request.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parseHTML:responseObject];
                    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
        
    [_queue addOperation:request];
     */
    
    [self parseHTML:nil];
}

- (void) parseHTML:(NSData *)data
{
    //To Get a queue of Image
    /*
    NSString* baseString=@"http://1.kangdm.com/comic_img/lz/t/%E9%93%81%E9%81%93%E5%B0%91%E5%A5%B3/%E5%85%A8%E4%B8%80%E5%8D%B7";
    
    for (NSInteger i = 0; i < 30; ++i) {
        NSString* urlStr = [NSString stringWithFormat:@"%@/%03ld.jpg", baseString, i];
        NSLog(@"%@", urlStr);
        
        NSURL* url = [NSURL URLWithString:urlStr];
        AFImageRequestOperation* request = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url]
                            success:^(UIImage *image) {
                               
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    [self addImage:image];
                                }];
                                
                            }];
        
        [_queue addOperation:request];
       
    }
     */
    
    KangDmParser *parser = [[[KangDmParser alloc] initWithUrl:[NSURL URLWithString:@"http://www.kangdm.com/comic/6553/tdsn-qyj/index.js"]] autorelease];

    for (NSInteger i = 0; i < 30; ++i) {
       
        NSURL *url = [parser urlForIndex:i];
        
        AFImageRequestOperation* request = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url]
                                                                                             success:^(UIImage *image) {
                                                                                                 
                                                                                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                                                     [self addImage:image];
                                                                                                 }];
                                                                                                 
                                                                                             }];
        
        [_queue addOperation:request];
        
    }


}

-(void) addImage:(UIImage *)image
{
    [_images addObject:image];
    if ([_delegate respondsToSelector:@selector(updateImageAtIndex:)]) {
        [_delegate updateImageAtIndex:[_images count] - 1];
    }
    
    NSLog(@"Current %d images", [_images count]);
}

- (NSUInteger) totalPages
{
    return [_images count];
}

@end
