//
//  SPGCSVAdapter.m
//  PGCSVEditor
//
//  Created by David Golightly on 10/14/11.
//  Copyright (c) 2011 Substantial. All rights reserved.
//

#import "SPGCSVAdapter.h"
#import "parseCSV.h"


@interface SPGCSVAdapter()
- (BOOL)cellExistsAtColumn:(NSInteger)colIndex row:(NSInteger)rowIndex;
@end


@implementation SPGCSVAdapter
@synthesize parser;
@synthesize data;

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        parser = [[CSVParser alloc] init];
        [parser openFile:[url path]];
        data = [[parser parseFile] mutableCopy];
    }
    return self;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    NSLog(@"count: %lu", [[self data] count]);
    return [[self data] count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSInteger colIndex = [[aTableView tableColumns] indexOfObject:aTableColumn];
    if (![self cellExistsAtColumn:colIndex row:rowIndex]) {
        return nil;
    }

    return [[[self data] objectAtIndex:rowIndex] objectAtIndex:colIndex];
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSInteger colIndex = [[aTableView tableColumns] indexOfObject:aTableColumn];
    if (![self cellExistsAtColumn:colIndex row:rowIndex]) {
        return;
    }

    NSMutableArray *mutableRow = [[[self data] objectAtIndex:rowIndex] mutableCopy];
    [mutableRow replaceObjectAtIndex:colIndex withObject:anObject];
    [[self data] replaceObjectAtIndex:rowIndex withObject:mutableRow];
}


- (BOOL)cellExistsAtColumn:(NSInteger)colIndex row:(NSInteger)rowIndex {
    if ([[self data] count] <= rowIndex) {
        return NO;
    }
    
    if ([[[self data] objectAtIndex:rowIndex] count] <= colIndex) {
        return NO;
    }

    return YES;
}

- (NSString *)text {
    
}

- (void)dealloc {
    [parser release];
    [data release];
    [super dealloc];
}

@end
