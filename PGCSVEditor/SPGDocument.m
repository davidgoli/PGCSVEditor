//
//  SPGDocument.m
//  PGCSVEditor
//
//  Created by David Golightly on 10/14/11.
//  Copyright (c) 2011 Substantial. All rights reserved.
//

#import "SPGDocument.h"
#import "SPGCSVAdapter.h"

@implementation SPGDocument
@synthesize tableView;
@synthesize adapter;
@synthesize url;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SPGDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [[self tableView] setDelegate:self];
    SPGCSVAdapter *a = [[SPGCSVAdapter alloc] initWithURL:[self url]];
    [self setAdapter:a];
    [a release];
    [[self tableView] setDataSource:a];
    [[self tableView] reloadData];
}


- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[inAbsoluteURL path]]) {
        [self setUrl:inAbsoluteURL];
        return YES;
    }
    return NO;
}

- (BOOL)writeToURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError {
    NSData *data = [[adapter text] dataUsingEncoding:NSUTF8StringEncoding];
    BOOL writeSuccess = [data writeToURL:inAbsoluteURL
                                 options:NSAtomicWrite error:outError];
    return writeSuccess;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}


- (void)dealloc {
    [tableView release];
    [adapter release];
    [url release];
    [super dealloc];
}


@end
