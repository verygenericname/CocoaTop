#import "GridCell.h"
#import "Proc.h"
#import "Column.h"

@implementation GridTableCell

- (instancetype)initWithId:(NSString *)reuseIdentifier proc:(PSProc *)proc columns:(NSArray *)columns size:(CGSize)size
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	self.textLabel.text = proc.name;
	NSString *full = [[[proc.args objectAtIndex:0] copy] autorelease];
	for (int i = 1; i < proc.args.count; i++)
		full = [full stringByAppendingFormat:@" %@", [proc.args objectAtIndex:i]];
	self.detailTextLabel.text = full;
//	self.detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
//	self.accessoryType = indexPath.row < 5 ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryNone;
//	self.indentationLevel = proc.ppid <= 1 ? 0 : 1;
	// Remember first column width
	firstCol = MIN(((PSColumn *)[columns objectAtIndex:0]).width, size.width);
	CGFloat totalCol = firstCol;
	// Get application icon
	if (proc.icon) {
		[self.imageView initWithImage:proc.icon];
		firstCol -= size.height; //proc.icon.size.width;
	}
	// Get other columns
	self.labels = [[NSMutableArray arrayWithCapacity:columns.count-1] retain];
	self.dividers = [[NSMutableArray arrayWithCapacity:columns.count-1] retain];
	for (int i = 1; i < columns.count /*&& totalCol < size.width*/; i++) {
		UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(totalCol, 0, 1, size.height)];
		[self.dividers addObject:divider];
		[divider release];
		divider.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
		[self.contentView addSubview:divider];

		PSColumn *col = [columns objectAtIndex:i];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(totalCol + 4, 0, col.width - 8, size.height)];
		[self.labels addObject:label];
		[label release];
		label.textAlignment = col.align;
		label.font = [UIFont systemFontOfSize:12.0];
		label.text = col.getData(proc);
		label.backgroundColor = [UIColor clearColor];
		label.tag = i;
		[self.contentView addSubview:label];
		totalCol += col.width;
	}
	return self;
}

+ (instancetype)cellWithId:(NSString *)reuseIdentifier proc:(PSProc *)proc columns:(NSArray *)columns size:(CGSize)size
{
	return [[[GridTableCell alloc] initWithId:reuseIdentifier proc:proc columns:columns size:size] autorelease];
}

- (void)updateWithProc:(PSProc *)proc columns:(NSArray *)columns
{
	for (int i = 1; i < columns.count; i++) {
		PSColumn *col = [columns objectAtIndex:i];
		UILabel *label = (UILabel *)[self viewWithTag:i];
		if (col.refresh)
			label.text = col.getData(proc);
	}
}

//- (void)drawRect:(CGRect)rect
//{
//	[super drawRect:rect];
//
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//	CGContextSetRGBStrokeColor(ctx, 1.0, .5, .5, 1.0);
//	CGContextSetLineWidth(ctx, 1.0);
//
//	for (int i = 0; i < [columns count]; i++) {
//		CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
//		CGContextMoveToPoint(ctx, f, 0);
//		CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
//	}
//	CGContextStrokePath(ctx);
//}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect frame;
	frame = self.contentView.frame;
		frame.origin.x = 5;
		self.contentView.frame = frame;
	frame = self.textLabel.frame;
		frame.origin.x = self.imageView.frame.size.width;
		if (frame.origin.x) frame.origin.x += 5;
		frame.size.width = firstCol - 5;
		self.textLabel.frame = frame;
	frame = self.detailTextLabel.frame;
		frame.origin.x = self.imageView.frame.size.width;
		if (frame.origin.x) frame.origin.x += 5;
		frame.size.width = firstCol - 5;
		self.detailTextLabel.frame = frame;
}

- (void)dealloc
{
	[_labels release];
	[_dividers release];
	[super dealloc];
}

@end


@implementation GridHeaderView

- (instancetype)initWithColumns:(NSArray *)columns size:(CGSize)size
{
	self = [super initWithReuseIdentifier:@"Header"];
	// Get column widths
	CGFloat totalCol = 0;
	self.labels = [[NSMutableArray arrayWithCapacity:columns.count] retain];
	self.dividers = [[NSMutableArray arrayWithCapacity:columns.count] retain];
	for (int i = 0; i < columns.count /*&& totalCol < size.width*/; i++) {
		PSColumn *col = [columns objectAtIndex:i];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(totalCol + 2, 0, col.width - 4, size.height)];
		[self.labels addObject:label];
		[label release];
		label.textAlignment = NSTextAlignmentCenter;//col.align;
		label.font = [UIFont boldSystemFontOfSize:16.0];
		label.adjustsFontSizeToFitWidth = YES;
		label.text = col.name;
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.tag = i+1;
		[self.contentView addSubview:label];
		totalCol += col.width;
	}
	return self;
}

+ (instancetype)headerWithColumns:(NSArray *)columns size:(CGSize)size
{
	return [[[GridHeaderView alloc] initWithColumns:columns size:size] autorelease];
}

- (void)dealloc
{
	[_labels release];
	[_dividers release];
	[super dealloc];
}

@end
