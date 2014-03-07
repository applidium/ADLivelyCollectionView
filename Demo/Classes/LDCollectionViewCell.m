//
//  LDCollectionViewCell.m
//  LivelyDemo
//
//  Created by Patrick Nollet on 07/03/2014.
//
//

#import "LDCollectionViewCell.h"

@implementation LDCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_textLabel release];
    [super dealloc];
}
@end
