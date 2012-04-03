//
//  WebParser.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/27/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Abstract Base Class, Parse a Volumn or a Chaper of an Online Comic
 */
@interface VolumnParser : NSObject
{
    NSUInteger _totalPages;
}

@property (readonly) NSUInteger totalPages;

- (NSURL *) urlForIndex: (NSUInteger) index;

@end



/*
 *Abstract Base, Prase Volumn List 
 */

@interface VolumnItem : NSObject {
    NSString *_title;
    NSURL *_url;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *url;

@end


@interface VolumnListParser : NSObject {
    
    NSMutableArray *_list;
}

@property (nonatomic,readonly) NSArray *list;

@end