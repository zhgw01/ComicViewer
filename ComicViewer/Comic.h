//
//  Comic.h
//  ComicViewer
//
//  Modal Class
//  Created by Gongwei Zhang on 3/16/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Volumn;

@interface Comic : NSObject {
    NSURL   *_baseUrl;
    NSMutableArray  *_allUrls;
}

@property (retain) NSMutableArray *allUrls;
@property (retain) NSURL *baseUrl;

-(id) initWithBaseUrl:(NSURL*) url;

@end
