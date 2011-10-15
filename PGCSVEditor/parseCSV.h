/*
 * cCSVParse, a small CVS file parser
 *
 * © 2007-2009 Michael Stapelberg and contributors
 * http://michael.stapelberg.de/
 *
 * This source code is BSD-licensed, see LICENSE for the complete license.
 *
 */
#import <Foundation/Foundation.h>


@interface CSVParser:NSObject {
	int fileHandle;
	int bufferSize;
	char delimiter;
	NSStringEncoding encoding;
}
-(id)init;
-(BOOL)openFile:(NSString*)fileName;
-(void)closeFile;
-(char)autodetectDelimiter;
-(char)delimiter;
-(void)setDelimiter:(char)newDelimiter;
-(void)setBufferSize:(int)newBufferSize;
-(NSMutableArray*)parseFile;
-(void)setEncoding:(NSStringEncoding)newEncoding;

- (void)setup:(NSArray *)lines; // override this
- (id)initWithFilepath:(NSString *)filepath;
@end

// Get the folder path for higher priority versions of CSV files.
NSString *getPriorityCSVPath();

// Get the folder path where higher priority versions of CSV files are
// staged while being created.
NSString *getPriorityCSVStagingPath();
