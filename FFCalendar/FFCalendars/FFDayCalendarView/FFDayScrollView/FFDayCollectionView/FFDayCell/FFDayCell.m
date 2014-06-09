//
//  FFDayCell.m
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 2/23/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import "FFDayCell.h"

#import "FFHourAndMinLabel.h"
#import "FFBlueButton.h"

@interface FFDayCell ()
@property (nonatomic, strong) NSMutableArray *arrayLabelsHourAndMin;
@property (nonatomic, strong) NSMutableArray *arrayButtonsEvents;
@property (nonatomic, strong) FFBlueButton *button;
@property (nonatomic) CGFloat yCurrent;
@property (nonatomic, strong) UILabel *labelWithSameYOfCurrentHour;
@property (nonatomic, strong) UILabel *labelRed;
@end

@implementation FFDayCell

@synthesize protocol;
@synthesize date;
@synthesize arrayLabelsHourAndMin;
@synthesize arrayButtonsEvents;
@synthesize button;
@synthesize yCurrent;
@synthesize labelWithSameYOfCurrentHour;
@synthesize labelRed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        arrayLabelsHourAndMin = [NSMutableArray new];
        arrayButtonsEvents = [NSMutableArray new];
        
        [self addLines];
        [self updateColors];
    }
    return self;
}

- (void)showEvents:(NSArray *)array {
    
    [self addButtonsWithArray:array];
}

- (void)addLines {
    
    CGFloat y = 0;
    
    NSDateComponents *compNow = [NSDate componentsOfCurrentDate];
    
    for (int hour=0; hour<=23; hour++) {
        
        for (int min=0; min<=45; min=min+MINUTES_PER_LABEL) {
            
            FFHourAndMinLabel *labelHourMin = [[FFHourAndMinLabel alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, HEIGHT_CELL_MIN) date:[NSDate dateWithHour:hour min:min]];
            [labelHourMin setTextColor:[UIColor grayColor]];
            if (min == 0) {
                [labelHourMin showText];
                CGFloat width = [labelHourMin widthThatWouldFit];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(labelHourMin.frame.origin.x+width+10, HEIGHT_CELL_MIN/2., self.frame.size.width-labelHourMin.frame.origin.x-width-20, 1.)];
                [view setAutoresizingMask:AR_WIDTH_HEIGHT];
                [view setBackgroundColor:[UIColor lightGrayCustom]];
                [labelHourMin addSubview:view];
            }
            [self addSubview:labelHourMin];
            [arrayLabelsHourAndMin addObject:labelHourMin];
            
            NSDateComponents *compLabel = [NSDate componentsWithHour:hour min:min];
            if (compLabel.hour == compNow.hour && min <= compNow.minute && compNow.minute < min+MINUTES_PER_LABEL) {
                labelRed = [self labelWithCurrentHourWithWidth:labelHourMin.frame.size.width yCurrent:labelHourMin.frame.origin.y];
                [self addSubview:labelRed];
                [labelRed setAlpha:0];
                labelWithSameYOfCurrentHour = labelHourMin;
            }
            
            y += HEIGHT_CELL_MIN;
        }
    }
}

- (UILabel *)labelWithCurrentHourWithWidth:(CGFloat)_width yCurrent:(CGFloat)_yCurrent {
    
    FFHourAndMinLabel *label = [[FFHourAndMinLabel alloc] initWithFrame:CGRectMake(.0, _yCurrent, _width, HEIGHT_CELL_MIN) date:[NSDate date]];
    [label showText];
    [label setTextColor:[UIColor redColor]];
    CGFloat width = [label widthThatWouldFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(label.frame.origin.x+width+10., HEIGHT_CELL_MIN/2., _width-label.frame.origin.x-width-20., 1.)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor redColor]];
    [label addSubview:view];
    
    return label;
}

- (void)addButtonsWithArray:(NSArray *)array {
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[FFBlueButton class]]) {
            [subview removeFromSuperview];
        }
    }
    [arrayButtonsEvents removeAllObjects];
    
    BOOL boolIsToday = [NSDate isTheSameDateTheCompA:[NSDate componentsOfCurrentDate] compB:[NSDate componentsOfDate:date]];
    [labelRed setAlpha:boolIsToday];
    [labelWithSameYOfCurrentHour setAlpha:!boolIsToday];
    
    NSArray *arrayEvents = array;
    
    if (arrayEvents) {
        
        for (FFEvent *event in arrayEvents) {
            
            CGFloat yTimeBegin;
            CGFloat yTimeEnd;
            
            for (FFHourAndMinLabel *label in arrayLabelsHourAndMin) {
                NSDateComponents *compLabel = [NSDate componentsOfDate:label.dateHourAndMin];
                NSDateComponents *compEventBegin = [NSDate componentsOfDate:event.dateTimeBegin];
                NSDateComponents *compEventEnd = [NSDate componentsOfDate:event.dateTimeEnd];
                
                if (compLabel.hour == compEventBegin.hour && compLabel.minute <= compEventBegin.minute && compEventBegin.minute < compLabel.minute+MINUTES_PER_LABEL) {
                    yTimeBegin = label.frame.origin.y+label.frame.size.height/2.;
                }
                if (compLabel.hour == compEventEnd.hour && compLabel.minute <= compEventEnd.minute && compEventEnd.minute < compLabel.minute+MINUTES_PER_LABEL) {
                    yTimeEnd = label.frame.origin.y+label.frame.size.height;
                }
            }
            
            FFBlueButton *_button = [[FFBlueButton alloc] initWithFrame:CGRectMake(70., yTimeBegin, self.frame.size.width-95., yTimeEnd-yTimeBegin)];
            [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_button setTitle:event.stringCustomerName forState:UIControlStateNormal];
            [_button setEvent:event];
            [_button setBackgroundColor:[self backgroundColorHighlighted:(_button == button)]];
            [_button.titleLabel setTextColor:[self textColorHighlighted:(_button == button)]];
            [_button.layer setBorderColor:[[self borderColor] CGColor]];
            
            [arrayButtonsEvents addObject:_button];
            [self addSubview:_button];
        }
    }
}

#pragma mark - Button Action

- (IBAction)buttonAction:(id)sender {

    button = (FFBlueButton *)sender;
    
    [self updateColors];
    
    if (protocol != nil && [protocol respondsToSelector:@selector(showViewDetailsWithEvent:cell:)]) {
        [protocol showViewDetailsWithEvent:button.event cell:self];
    }
}

#pragma mark - AD Customization

-(void)unselectedAll
{
    //No more cell selected
    
    button = nil;
    [self updateColors];
}

- (void)updateColors
{
    for(FFBlueButton *currButton in arrayButtonsEvents)
    {
        BOOL isHighlighted = (button==currButton);
        [currButton.titleLabel setTextColor:[self textColorHighlighted:isHighlighted]];
        [currButton setBackgroundColor:[self backgroundColorHighlighted:isHighlighted]];
        [currButton.layer setShadowOpacity:(isHighlighted ? 1.0 : 0.0)];
        [currButton.layer setShadowColor:[[self shadowColorHighlighted:isHighlighted] CGColor]];
        
        if (isHighlighted)
            [self bringSubviewToFront:currButton];
    }
    
    [self bringSubviewToFront:labelRed];
}

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
             NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0],
             NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
             NSParagraphStyleAttributeName : paragraphStyle
             };
}

- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:12.0],
             NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
             NSParagraphStyleAttributeName : paragraphStyle
             };
}

- (UIColor *)backgroundColorHighlighted:(BOOL)selected
{
    return [UIColor colorWithHexString:(selected ? @"35b1f1" : @"d2ebf9")];
}

- (UIColor *)shadowColorHighlighted:(BOOL)selected
{
    return selected ? [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:.5f] : [UIColor clearColor];
}

- (UIColor *)textColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"21729c"];
}

- (UIColor *)borderColor
{
    return [self backgroundColorHighlighted:YES];
}

@end
