//
//  ViewController.h
//  dox
//
//  Created by Ray Wenderlich on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface ViewController : UIViewController <UITextViewDelegate>

@property (strong) Note * doc;
@property (strong) IBOutlet UITextView * noteView;

@end
