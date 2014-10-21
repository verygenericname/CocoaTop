#import <UIKit/UIKit.h>
#import "Proc.h"

@interface PSColumn : NSObject
{
}
// Full column name (in settings)
@property (retain) NSString *descr;
// Short name (in header)
@property (retain) NSString *name;
// NSTextAlignmentLeft or NSTextAlignmentRight
@property (assign) NSTextAlignment align;
// Minimal column width
@property (assign) NSInteger width;
// Sort comparator
@property (assign) NSComparator sort;
// Id
@property (assign) int cid;

- (instancetype)initWithName:(NSString *)name descr:(NSString *)descr align:(NSTextAlignment)align width:(NSInteger)width id:(int)cid sort:(NSComparator)sort;
+ (instancetype)psColumnWithName:(NSString *)name descr:(NSString *)descr align:(NSTextAlignment)align width:(NSInteger)width id:(int)cid sort:(NSComparator)sort;
+ (NSArray *)psColumnsArray;
- (NSString *)getDataForProc:(PSProc *)proc;

@end