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


inline static NSString* keyForURL(NSURL* url) {
	return [NSString stringWithFormat:@"VolumnImageLoader-%u", [[url description] hash]];
}

#define kImageNotificationLoaded(s) [@"VolumnImageLoaderNotificationLoaded-" stringByAppendingString:keyForURL(s)]
#define kImageNotificationLoadFailed(s) [@"VolumnImageLoaderNotificationLoadFailed-" stringByAppendingString:keyForURL(s)]

@interface Volumn()
-(void) addImage: (UIImage *) image forUrl:(NSURL *) url;
@end


@implementation Volumn

@synthesize url = _url;
@synthesize totalPages = _totalPages;
@synthesize images = _images;
@synthesize delegate = _delegate;
@synthesize started = _started;

-(id) initWithURL:(NSURL *)url
{
    if ((self = [super init])) {
        _url = [url retain];
        _images = [[NSMutableArray alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:8];
        _started = FALSE;
    }
    
    return self;
}

-(void) dealloc
{
    [_url release];
    [_queue release];
    [_images release];
    [_delegate release];
    [_parser release];
}

#pragma mark - Images Downloading


- (void) startDownloading
{
    
    if (_started) 
        return;
    else
        _started = TRUE;
    
    _parser = [[KangDmParser alloc] initWithUrl:self.url];
    
    NSUInteger total = _parser.totalPages;

    for (NSUInteger i = 0; i < total; ++i) {
       
        NSURL *url = [_parser urlForIndex:i];
        
        /*
        AFImageRequestOperation* request = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url]
                                            success:^(UIImage *image) {
                                                                                                 
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                                                     
                                    [self addImage:image];
                                                                                                 
                                }];
                                                                                                 
                                }];
         */
        
        AFImageRequestOperation *request = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:url] imageProcessingBlock:nil cacheName:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            [self addImage:image forUrl:url];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSNotification *notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(url) object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, @"error", url, @"url", nil]];
            
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
        }];
        
        [_queue addOperation:request];
        
    }


}

-(void) addImage:(UIImage *)image forUrl:(NSURL *)url
{
    [_images addObject:image];
    /*
    if ([_delegate respondsToSelector:@selector(updateImageAtIndex:)]) {
        [_delegate updateImageAtIndex:[_images count] - 1];
    }
     */
    
    NSNotification *notification = [NSNotification notificationWithName:kImageNotificationLoaded(url) object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:image, @"image", url, @"url", nil]];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    
    NSLog(@"Current %d images", [_images count]);
}

- (NSUInteger) totalPages
{
    return [_images count];
}

@end
