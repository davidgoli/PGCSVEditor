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
+ (NSString *)lineEndingsAtPath:(NSURL *)url;
@end


@implementation SPGCSVAdapter
@synthesize parser;
@synthesize data;
@synthesize lineEnding;

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        parser = [[CSVParser alloc] init];
        [parser openFile:[url path]];
        data = [[parser parseFile] mutableCopy];
        lineEnding = [[SPGCSVAdapter lineEndingsAtPath:url] copy];
        NSLog(@"line ending is: %@", [[lineEnding stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]);
    }
    return self;
}


+ (NSString *)lineEndingsAtPath:(NSURL *)url {
    NSString *fileString = [NSString stringWithContentsOfURL:url usedEncoding:nil error:nil];
    NSCharacterSet *lineEndings = [NSCharacterSet characterSetWithCharactersInString:@"\n\r"];
    NSRange lineEndingRange = [fileString rangeOfCharacterFromSet:lineEndings];
    NSRange extent = [fileString rangeOfCharacterFromSet:lineEndings options:nil range:NSMakeRange(lineEndingRange.location+1, 2)];
    lineEndingRange.length += extent.length;
    return [fileString substringWithRange:lineEndingRange];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
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
    NSMutableString *str = [NSMutableString string];
    for (NSArray *row in [self data]) {
        for (int i=0; i<[row count]; i++) {
            NSString *col = [row objectAtIndex:i];
            [str appendString:col];
            if (i < [row count]-1) {
                [str appendString:@","];
            }
        }
        if (row != [[self data] lastObject]) {
            [str appendString:lineEnding];
        }
    }
    return str;
}

- (void)dealloc {
    [parser release];
    [data release];
    [lineEnding release];
    [super dealloc];
}

@end
