//
//  FFEvent.h
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 2/16/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FFEventStatus) {
    FFEventStatusPositive = 1,
    FFEventStatusNegative = 2,
    FFEventStatusRedo = 3
};

typedef NS_ENUM(NSInteger, FFEventType) {
    FFEventTypeCall = 1, //Have to be always first
    FFEventTypeVisit = 2,
    FFEventTypeEmail = 3 //Have to be always last
};

@protocol FFEventDelegate <NSObject>

-(void)event:(id)event changeStatus:(FFEventStatus)status;

@end

@interface FFEvent : NSObject

@property (nonatomic, strong) NSString *stringCustomerName;
@property (nonatomic, strong) NSNumber *numCustomerID;
@property (nonatomic, strong) NSDate *dateDay;
@property (nonatomic, strong) NSDate *dateTimeBegin;
@property (nonatomic, strong) NSDate *dateTimeEnd;
@property (nonatomic, strong) NSMutableArray *arrayWithGuests;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) id dataObject;
@property (nonatomic, strong) id<FFEventDelegate> delegate;

@end
