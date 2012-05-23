//
//  ContentController.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "ContentController.h"

@interface ContentController()
-(void) clickButton: (UIButton *) sender;
@end

@implementation ContentController

@synthesize view = _view;


- (id) initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _data = [data copy];
        _sortedKeys = [[[_data allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] retain];
        
        if (1 == [_data count]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            /*
            button.backgroundColor  = [UIColor colorWithRed:246.0 / 255 green:1.0 blue:244.0 / 255.0 alpha:1.0f];
            NSString *title = [_sortedKeys lastObject];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            */
            button.backgroundColor  = [UIColor colorWithRed:246.0 / 255 green:1.0 blue:244.0 / 255.0 alpha:1.0f];
            [button setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            _view = button;
        } else {
            UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableview.dataSource = self;
            tableview.delegate = self;
            tableview.backgroundColor = [UIColor colorWithRed:246.0 / 255 green:1.0 blue:244.0 / 255.0 alpha:1.0f];
            _view = tableview;
        }
    }
       
    return self;
}

- (void) dealloc
{
    [_data release];
    _data = nil;
    
    [_sortedKeys release];
    _sortedKeys = nil;
    
    [_view release];
    _view = nil;
    
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Content Controller Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
       
    }
    
    // Configure the cell...
    cell.textLabel.text = [_sortedKeys objectAtIndex:indexPath.row];    
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You click table");
}

#pragma mark - Button Delegate
- (void) clickButton:(UIButton *)sender
{
    NSLog(@"Click Button");
}


@end
