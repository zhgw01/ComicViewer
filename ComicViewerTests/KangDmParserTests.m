//
//  KangDmParserTests.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "KangDmParserTests.h"

@implementation KangDmParserTests


- (void) setUp
{
    _parser = [[KangDmParser alloc] initWithUrl:[NSURL URLWithString:@"http://www.kangdm.com/comic/6553/tdsn-qyj/"]];
}

- (void) tearDown
{
    [_parser release];
}


-(void) testTotalPages
{
    STAssertTrue(_parser.totalPages == 102, @"You get wrong page numbers");
}

-(void) testURL
{
    NSURL *sourceUrl = [NSURL URLWithString:@"http://1.kangdm.com/comic_img/lz/t/%E9%93%81%E9%81%93%E5%B0%91%E5%A5%B3/%E5%85%A8%E4%B8%80%E5%8D%B7/001.jpg"];
    
    NSURL *targetURL = [_parser urlForIndex:1];
    STAssertTrue([sourceUrl isEqual:targetURL], @"You may not implement urlForIndex properly");
}

-(void)testWrongURL
{
    KangDmParser *anotherParser = [[KangDmParser alloc] initWithUrl:nil];
    STAssertTrue(anotherParser.totalPages == 0, @"You get wrong page numbers");
    [anotherParser release];
}

-(void)testZListParser
{
    
    KangDmVolumnListParser *listParser = [[KangDmVolumnListParser alloc] initWithUrl:[NSURL URLWithString:@"http://www.kangdm.com/comic/8931/"]];
    
    NSUInteger count = [listParser.list count];
    
    STAssertTrue(23 == count, @"list parser error");
    
    [listParser release];
}


@end
