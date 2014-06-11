//
//  FFConstants.h
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 2/15/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <UIKit/UIKit.h>

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

//#define dictWeekNumberName @{@1:@"Domingo", @2:@"Segunda-feira", @3:@"Terça-feira", @4:@"Quarta-feira", @5:@"Quinta-feira", @6:@"Sexta-feira", @7:@"Sábado"}
//#define arrayWeekAbrev @[@"dom", @"seg", @"ter", @"qua", @"qui", @"sex", @"sáb"]
//#define arrayMonthName @[@"Janeiro", @"Fevereiro", @"Março", @"Abril", @"Maio", @"Junho", @"Julho", @"Agosto", @"Setembro", @"Outubro", @"Novembro", @"Dezembro"]

#define dictWeekNumberName @{@1:NSLocalizedString(@"kMonday","Calendario"), @2:NSLocalizedString(@"kTuesday","Calendario"), @3:NSLocalizedString(@"kWednesday","Calendario"), @4:NSLocalizedString(@"kThursday","Calendario"), @5:NSLocalizedString(@"kFriday","Calendario"), @6:NSLocalizedString(@"kSaturday","Calendario"), @7:NSLocalizedString(@"kSunday","Calendario")}

#define arrayWeekAbrev @[NSLocalizedString(@"kMon","Calendario"),NSLocalizedString(@"kTue","Calendario"),NSLocalizedString(@"kWed","Calendario"),NSLocalizedString(@"kThu","Calendario"),NSLocalizedString(@"kFri","Calendario"),NSLocalizedString(@"kSat","Calendario"),NSLocalizedString(@"kSun","Calendario")]

#define arrayMonthName @[NSLocalizedString(@"kJanuary","Calendario"),NSLocalizedString(@"kFebruary","Calendario"),NSLocalizedString(@"kMarch","Calendario"),NSLocalizedString(@"kApril","Calendario"),NSLocalizedString(@"kMay","Calendario"),NSLocalizedString(@"kJune","Calendario"),NSLocalizedString(@"kJuly","Calendario"),NSLocalizedString(@"kAugust","Calendario"),NSLocalizedString(@"kSeptember","Calendario"),NSLocalizedString(@"kOctober","Calendario"),NSLocalizedString(@"kNovember","Calendario"),NSLocalizedString(@"kDecember","Calendario")]

#define arrayMonthNameAbrev @[NSLocalizedString(@"kJen","Calendario"),NSLocalizedString(@"kFeb","Calendario"),NSLocalizedString(@"kMar","Calendario"),NSLocalizedString(@"kApr","Calendario"),NSLocalizedString(@"kMay","Calendario"),NSLocalizedString(@"kJun","Calendario"),NSLocalizedString(@"kJul","Calendario"),NSLocalizedString(@"kAug","Calendario"),NSLocalizedString(@"kSep","Calendario"),NSLocalizedString(@"kOct","Calendario"),NSLocalizedString(@"kNov","Calendario"),NSLocalizedString(@"kDec","Calendario")]


#define BUTTON_HEIGHT 44.

#define STORYBOARD_ID_ROOTVC @"root"

#define SPACE_COLLECTIONVIEW_CELL_YEAR 30.
#define SPACE_COLLECTIONVIEW_CELL 2.
#define HEADER_HEIGHT_MONTH 32.
#define HEADER_HEIGHT_SCROLL 100.
#define REUSE_IDENTIFIER_MONTH_CELL @"monthCell"
#define REUSE_IDENTIFIER_MONTH_HEADER @"headerCollection"

#define REUSE_IDENTIFIER_DAY_CELL @"dayCell"

#define MINUTES_INTERVAL 4.
#define HEIGHT_CELL_HOUR 100.
#define HEIGHT_CELL_MIN HEIGHT_CELL_HOUR/MINUTES_INTERVAL
#define MINUTES_PER_LABEL 60./MINUTES_INTERVAL

#define Customer_ID @"idCustomer"
#define Customer_NOME @"nmCustomer"

#define AR_WIDTH_HEIGHT UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#define AR_TOP_BOTTOM UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
#define AR_LEFT_RIGHT UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
#define AR_LEFT_BOTTOM UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin

@interface FFConstants

@end
