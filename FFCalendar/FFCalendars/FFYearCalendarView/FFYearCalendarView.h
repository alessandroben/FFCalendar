//
//  FFYearCalendarView.h
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 3/18/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <UIKit/UIKit.h>

@protocol FFYearCalendarViewProtocol <NSObject>
@required
- (void)showMonthCalendar;
@end

@interface FFYearCalendarView : UIView

- (id)initWithFrame:(CGRect)frame andEventsDictionary:(NSMutableDictionary *)dictionary;

@property (nonatomic, strong) id<FFYearCalendarViewProtocol> protocol;
@property (nonatomic, strong) NSMutableDictionary *dictEvents;

- (void)invalidateLayout;

@end
