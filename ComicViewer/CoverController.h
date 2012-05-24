//
//  CoverController.h
//  ComicViewer
//
//  Created by Gongwei Zhang on 5/17/12.
//  Copyright (c) 2012 autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"

@interface CoverController : UIViewController<CoverViewDelegate>
{
    NSDictionary *_data;
}

@end
