//
//  KangDmParserTests.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 3/18/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "KangDmParserTests.h"

@implementation KangDmParserTests

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

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
    
}

-(void) testURL
{
    
}

@end
