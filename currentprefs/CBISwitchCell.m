#import "CBISwitchCell.h"
#import "UIColor+Hex.h"

@implementation CBISwitchCell

-(id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier { //init method
	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier]; //call the super init method
	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:[UIColor pf_colorWithHexString:@"36DBEC" alpha:1.0f]]; //change the switch color
	}
	return self;
}

@end