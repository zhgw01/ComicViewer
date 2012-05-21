//
//  TypeDetailView.m
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import "TypeDetailView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TypeDetailView

@synthesize data = _data;

- (void) setup
{
    _data = [[NSArray alloc] initWithObjects:@"t1", @"t2", nil];
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithRed:246.0 / 255 green:1.0 blue:244.0 / 255.0 alpha:1.0f];
    _tableView.rowHeight = 50;
    [self addSubview:_tableView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) dealloc
{
    self.data = nil;
    [super dealloc];
}

#pragma mark - Properties
-(void) setData:(NSArray *)data
{
    if (data != _data) {
        _data = [data retain];
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:self.bounds];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [self addSubview:_tableView];
        }
        else
            [_tableView reloadData];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       /*
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        [cell.contentView.layer insertSublayer:gradient atIndex:0]; 
        */
    }
    
    // Configure the cell...
    //cell.contentView.backgroundColor = [UIColor colorWithRed:246.0 / 255 green:1.0 blue:244.0 / 255.0 alpha:1.0f];
    cell.textLabel.text = [[_data objectAtIndex:indexPath.row] description];
   
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You click table");
}


@end
