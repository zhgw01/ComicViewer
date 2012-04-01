//
//  GridViewController.m
//  Nav
//
//  Created by Gongwei Zhang on 3/31/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

//#import "UIView+GMGridViewAdditions.h"
#import "GridViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "OptionsViewController.h"


#define NUMBER_ITEMS_ON_LOAD 250
#define NUMBER_ITEMS_ON_LOAD2 30

#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 


@interface GridViewController() 

- (void) addMoreItem;
- (void) removeItem;
- (void) refreshItem;
- (void) presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;

@end


@implementation GridViewController

- (id)init
{
    if ((self = [super init])) {
        self.title = @"Grid View";
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMoreItem)];
       
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = 10;
        
        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeItem)];
        UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshItem)];
        
        UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentOptions:)];
        
        if ([self.navigationItem respondsToSelector:@selector(rightBarButtonItems)]) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton,space, removeButton, space2, refreshButton, optionsButton, nil];
        } else {
            self.navigationItem.rightBarButtonItem = addButton;
        }
        
        [addButton release];
        [space release];
        [removeButton release];
        [space2 release];
        [refreshButton release];
        [optionsButton release];
        
        _data = [[NSMutableArray alloc] init];
       
        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD; i ++) 
        {
            [_data addObject:[NSString stringWithFormat:@"A %d", i]];
        }
        
        _data2 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD2; i ++) 
        {
            [_data2 addObject:[NSString stringWithFormat:@"B %d", i]];
        }
        
        _currentData = _data;
        
    }
    
    return  self;
}

- (void) dealloc
{
    [_gridView release];
    _gridView = nil;
    [_optionsPopOver release];
    _optionsPopOver = nil;
    [_data release];
    _data = nil;
    [_data2 release];
    _data2 = nil;
    [super dealloc];
}

#pragma mark controller events

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 15;
    
    _gridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.style = GMGridViewStyleSwap;
    _gridView.itemSpacing = spacing;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gridView.centerGrid = YES;
    _gridView.actionDelegate = self;
    _gridView.sortingDelegate = self;
    _gridView.transformDelegate = self;
    _gridView.dataSource = self;
    [self.view addSubview:_gridView];
    
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40, 40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    
    UISegmentedControl *dataSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Data set 1", @"Data Set 2", nil]];
    [dataSegment sizeToFit];
    dataSegment.frame = CGRectMake(5, 
                                   self.view.bounds.size.height - dataSegment.bounds.size.height -5,
                                   dataSegment.bounds.size.width,
                                   dataSegment.bounds.size.height);
    dataSegment.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    dataSegment.tintColor = [UIColor greenColor];
    dataSegment.selectedSegmentIndex = 0;
    [dataSegment addTarget:self action:@selector(dataSetChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dataSegment];
    [dataSegment release];
    
    OptionsViewController *optionController = [[OptionsViewController alloc] init];
    optionController.gridView = _gridView;
    optionController.contentSizeForViewInPopover = CGSizeMake(400, 500);
    
    _optionsNav = [[UINavigationController alloc] initWithRootViewController:optionController];
    [optionController release];
    
    if (INTERFACE_IS_PHONE) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(optionsDoneAction)];
        optionController.navigationItem.rightBarButtonItem = doneButton;
        [doneButton release];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gridView.mainSuperView = self.navigationController.view;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gridView = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark Grid View DataSource

- (NSInteger) numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return CGSizeMake(170, 135);
        }
        else
        {
            return CGSizeMake(140, 110);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}


- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor redColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        if([view respondsToSelector:@selector(shakeStatus:)])
            NSLog(@"Set the correct UIView");
        else
            NSLog(@"UIView doesn't support shakeStatus:");
        
               
        cell.contentView = view;
        [view release];
    }
                   
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

#pragma mark GridView Action Delegate

-(void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                    message:@"Are you sure you want to delete this item"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gridView removeObjectAtIndex:_lastDeleteItemIndexAsked animated:GMGridViewItemAnimationFade];
    }
}

#pragma mark Grid View Sorting Delegate

-(void) GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                     delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     } completion:nil
     ];
}

-(void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                         
                     } completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)view atIndex:(NSInteger)index
{
    return YES;
}

-(void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

-(void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

#pragma mark Draggable GridView Transforming Delegate

- (CGSize) GMGridView: (GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return CGSizeMake(320, 210);
        }
        else
        {
            return CGSizeMake(300, 310);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return CGSizeMake(700, 530);
        }
        else
        {
            return CGSizeMake(600, 500);
        }
    }
}


- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[[UIView alloc] init] autorelease];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (INTERFACE_IS_PHONE) {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        label.font = [UIFont boldSystemFontOfSize:20];
    }
    
    [fullView addSubview:label];
    [label release];
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                    delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                         
                     } completion:nil
     ];
}


- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     } completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(GMGridViewCell *)cell
{
    
}

#pragma mark private methods

- (void)addMoreItem
{
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() %1000)];
    
    [_currentData addObject:newItem];
    [_gridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void) removeItem
{
    if ([_currentData count] > 0) {
        NSInteger index = [_currentData count] - 1;
        
        [_gridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
}

- (void) refreshItem
{
    if ([_currentData count] > 0) {
        int index = [_currentData count] - 1;
        
        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
        [_currentData replaceObjectAtIndex:index withObject:newMessage];
        [_gridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" 
                                                        message:info 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void) dataSetChange:(UISegmentedControl *)control
{
    _currentData = ([control selectedSegmentIndex] == 0) ? _data : _data2;
    [_gridView reloadData];
}

- (void)presentOptions:(UIBarButtonItem *)barButton
{
    if (INTERFACE_IS_PHONE) {
        [self presentModalViewController:_optionsNav animated:YES];
    }
    else
    {
        if (![_optionsPopOver isPopoverVisible]) {
            if (!_optionsPopOver) {
                _optionsPopOver = [[UIPopoverController alloc] initWithContentViewController:_optionsNav];
            }
            
            [_optionsPopOver presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self optionsDoneAction];
        }
    }
}

- (void)optionsDoneAction
{
    if (INTERFACE_IS_PHONE) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [_optionsPopOver dismissPopoverAnimated:YES];
    }
}



@end
