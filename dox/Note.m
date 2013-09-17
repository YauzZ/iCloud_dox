//
//  Note.m
//  dox
//
//  Created by Ray Wenderlich on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize noteContent;

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([contents length] > 0) {
        self.noteContent = [[NSString alloc] initWithBytes:[contents bytes] 
                                                    length:[contents length] 
                                                  encoding:NSUTF8StringEncoding];
        
    } else {
        self.noteContent = @"Empty"; // When the note is created we assign some default content
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" 
                                                        object:self];        
    
    return YES;
    
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError 
{
    
    if ([self.noteContent length] == 0) {
        self.noteContent = @"Empty";
    }
    
    return [NSData dataWithBytes:[self.noteContent UTF8String] 
                          length:[self.noteContent length]];
    
}

@end
