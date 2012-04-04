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
 *Abstract Base Class, Parse Volumn List 
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

/*
 * Abstract Base Class, Parse Comic List
 */

@interface ComicItem : NSObject {
@private
    NSString *_title;
    NSURL *_thumbnail;
    NSURL *_url;
    NSString *_newestVolumn;
    NSURL *_newestVolunmnUrl;
    NSDate *_updateDate;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *thumbnail;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *newestVolumn;
@property (nonatomic, retain) NSURL  *newestVolumnUrl;
@property (nonatomic, retain) NSDate *updateDate;

@end


@interface ComicParser : NSObject {
@protected
    NSMutableArray *_list;
    
    //TODO: support search
}

@property (nonatomic, readonly) NSArray *list;

-(NSURL *) getURlForTitle:(NSString *) title;

@end










