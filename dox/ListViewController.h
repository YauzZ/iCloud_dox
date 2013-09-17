//
//  ListViewController.h
//  dox
//
//  Created by Ray Wenderlich on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@class ViewController;

@interface ListViewController : UITableViewController

@property (strong) NSMutableArray * notes;
@property (strong) ViewController * detailViewController;
@property (strong) NSMetadataQuery *query;

- (void)loadNotes;

@end
