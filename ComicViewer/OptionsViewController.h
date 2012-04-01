//
//  OptionsViewController.h
//  GMGridView
//
//  Created by Gulam Moledina on 11-11-01.
//  Copyright (c) 2011 GMoledina.ca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMGridView;

@interface OptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView *_tableView;
}


@property (nonatomic, retain) GMGridView *gridView;

@end
