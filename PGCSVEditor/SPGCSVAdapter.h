//
//  SPGCSVAdapter.h
//  PGCSVEditor
//
//  Created by David Golightly on 10/14/11.
//  Copyright (c) 2011 Substantial. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSVParser;

@interface SPGCSVAdapter : NSObject <NSTableViewDataSource>
@property (nonatomic, retain) CSVParser *parser;
@property (nonatomic, retain) NSMutableArray *data;

- (id)initWithURL:(NSURL *)url;

- (NSString *)text;

@end
