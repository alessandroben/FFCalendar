//
//  BlueButton.m
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 2/19/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import "FFBlueButton.h"

@implementation FFBlueButton

#pragma mark - Synthesize

@synthesize event;

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        self.titleLabel.numberOfLines = 0;
        [self setBackgroundColor:[UIColor colorWithRed:49./255. green:181./255. blue:247./255. alpha:0.5]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.shadowColor = [[UIColor clearColor] CGColor];
        self.layer.shouldRasterize = YES;
        self.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowOpacity = 0.0f;
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

@end
