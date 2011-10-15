//
//  SPGDocument.h
//  PGCSVEditor
//
//  Created by David Golightly on 10/14/11.
//  Copyright (c) 2011 Substantial. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SPGCSVAdapter;

@interface SPGDocument : NSDocument <NSTableViewDelegate>

@property (nonatomic, retain) IBOutlet NSTableView *tableView;
@property (nonatomic, retain) SPGCSVAdapter *adapter;
@property (nonatomic, copy) NSURL *url;

@end
