//
//  EditView.m
//  FFCalendar
//
//  Created by Fernanda G. Geraissate on 2/19/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import "FFEditEventView.h"

#import "FFButtonWithDatePopover.h"
#import "FFButtonWithHourPopover.h"
#import "FFSearchBarWithAutoComplete.h"
#import "FFGuestsTableView.h"
#import "ITObjectCacher.h"
#import "ITLocationBroker.h"
#import "ITHQAnnotation.h"

#import "ITSoggetti.h"
#import "ITProvincia.h"
#import "ITCap.h"
#import "ITAttivita.h"
#import "ITStatoAttivita.h"

#import "SVProgressHUD.h"

@interface FFEditEventView () <UIGestureRecognizerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) FFEvent *event;
@property (nonatomic, strong) ITSoggetti *customer;
@property (nonatomic, strong) UIButton *buttonCancel;
@property (nonatomic, strong) UIButton *buttonDone;
@property (nonatomic, strong) UIButton *buttonDelete;
@property (nonatomic, strong) UILabel *labelEventName;
@property (nonatomic, strong) FFSearchBarWithAutoComplete *searchBarCustom;
@property (nonatomic, strong) FFButtonWithDatePopover *buttonDate;
@property (nonatomic, strong) FFButtonWithHourPopover *buttonTimeBegin;
@property (nonatomic, strong) FFButtonWithHourPopover *buttonTimeEnd;
@property (nonatomic, strong) FFGuestsTableView *tableViewGuests;
@end

@implementation FFEditEventView

#pragma mark - Synthesize

@synthesize protocol;
@synthesize customer;
@synthesize event;
@synthesize buttonDone;
@synthesize buttonCancel;
@synthesize buttonDelete;
@synthesize labelEventName;
@synthesize searchBarCustom;
@synthesize buttonDate;
@synthesize buttonTimeBegin;
@synthesize buttonTimeEnd;
@synthesize tableViewGuests;

#pragma mark - Lifecycle

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

- (id)initWithFrame:(CGRect)frame event:(FFEvent *)_event {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        event = _event;
        if (event.numCustomerID)
            customer = [ITSoggetti customerWithPrimaryKey:[event numCustomerID]];
        
        [self setBackgroundColor:[UIColor lightGrayCustom]];
        [self.layer setBorderColor:[UIColor lightGrayCustom].CGColor];
        [self.layer setBorderWidth:2.];
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [gesture setDelegate:self];
        [self addGestureRecognizer:gesture];
        
        [self addButtonCancel];
        [self addButtonDone];
        [self addSearchBar];
        [self addButtonDate];
        [self addButtonTimeBegin];
        [self addButtonTimeEnd];
        [self addButtonDelete];
        [self addtableViewGuests];
        [self addEventTyeSegmentedControl];
        
        NSInteger esitoAppuntamento = 0;
        if ([event.dataObject isKindOfClass:[ITAttivita class]])
            esitoAppuntamento = [[[event.dataObject statoAttivita] codice] integerValue];
        else
        {
            Appointment *transitionAppointment = [Appointment MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"guid == %@",event.dataObject]];
            esitoAppuntamento = [transitionAppointment.state integerValue];
        }
        
        if (esitoAppuntamento <= 0)
            [self addEsitoButtonWithCustomView:self];
        else
            [self addNoteButtonWithCustomView:self];
        
        if(customer)
            [self addCustomerLocationMapWithCustomView:self];
        
    }
    return self;
}

#pragma mark - Button Actions

- (IBAction)buttonCancelAction:(id)sender {
    
    if (protocol != nil && [protocol respondsToSelector:@selector(removeThisView:)]) {
        [protocol removeThisView:self];
    }
}

-(void)addCustomerLocationMapWithCustomView:(UIView *)customView
{
    ITLocationPlace *customerPlace = [[ITLocationPlace alloc] init];
    
    customerPlace.indirizzo = customer.via;
    customerPlace.citta = customer.citta;
    customerPlace.cap = customer.cap.codice;
    customerPlace.province = customer.provincia.codice;
    customerPlace.stati = @"Italia";
    
    [[ITLocationBroker sharedBroker] geocodedCoordinatesFromLocaction:customerPlace withBlock:^(CLLocationCoordinate2D coordinates, NSError *message) {
        
        if (!message)
        {
            MKMapView *customerMap = [[MKMapView alloc] initWithFrame:CGRectMake(0,buttonTimeEnd.frame.origin.y+buttonTimeEnd.frame.size.height+140, customView.frame.size.width-70, 300)];
            
            [customerMap setDelegate:self];
            [customerMap setCenterCoordinate:coordinates];
            
            ITHQAnnotation *annotation = [[ITHQAnnotation alloc] initWithLatitudine:[NSString stringWithFormat:@"%.4f", coordinates.latitude] longitudine:[NSString stringWithFormat:@"%.4f", coordinates.longitude] titolo:customer.ragioneSociale sottoTitolo:customer.codice];
            [customerMap addAnnotation:annotation];
            
            [customView addSubview:customerMap];
            [customerMap setCenter:CGPointMake(customView.frame.size.width/2, customerMap.center.y)];
        }
    }];
}

-(void)addNoteButtonWithCustomView:(UIView *)customView
{
    UIButton *note = [[UIButton alloc] initWithFrame:CGRectMake(0,buttonTimeEnd.frame.origin.y+buttonTimeEnd.frame.size.height+70, customView.frame.size.width-70, 50)];
    note.layer.cornerRadius = 5.0f;
    note.backgroundColor = [UIColor colorWithHexString:@"2ecc71"];
    [note addTarget:self action:@selector(noteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [note setTitle:@"Note" forState:UIControlStateNormal];
    
    [customView addSubview:note];
    [note setCenter:CGPointMake(customView.frame.size.width/2, note.center.y)];
}

-(void)addEsitoButtonWithCustomView:(UIView *)customView
{
    UIButton *positive = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonTimeEnd.frame.origin.y+buttonTimeEnd.frame.size.height+70, 150, 50)];
    positive.layer.cornerRadius = 5.0f;
    positive.backgroundColor = [UIColor colorWithHexString:@"2ecc71"];
    [positive addTarget:self action:@selector(esitoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [positive setTitle:@"Positivo" forState:UIControlStateNormal];
    [positive setTag:FFEventStatusPositive];
    
    UIButton *negative = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonTimeEnd.frame.origin.y+buttonTimeEnd.frame.size.height+70, 150, 50)];
    negative.layer.cornerRadius = 5.0f;
    negative.backgroundColor = [UIColor colorWithHexString:@"e74c3c"];
    [negative addTarget:self action:@selector(esitoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [negative setTitle:@"Negativo" forState:UIControlStateNormal];
    [negative setTag:FFEventStatusNegative];
    
    [customView addSubview:positive];
    [customView addSubview:negative];
    
    [positive setCenter:CGPointMake(customView.frame.size.width/4+15, positive.center.y)];
    [negative setCenter:CGPointMake(customView.frame.size.width*3/4-15, positive.center.y)];
    
    //    [self addSubview:positive];
    //    [self addSubview:negative];
}

-(void)noteButtonPressed:(UIButton *)sender
{
    if([self.event.delegate respondsToSelector:@selector(eventNoteEditor:)])
    {
        [self.event.delegate eventNoteEditor:self.event];
    }
}

-(void)esitoButtonPressed:(UIButton *)sender
{
    FFEventStatus status = sender.tag;
    
    if([self.event.delegate respondsToSelector:@selector(event:changeStatus:)])
    {
        [self.event.delegate event:self.event changeStatus:status];
    }
}

- (IBAction)buttonDoneAction:(id)sender {
    
    // SVProgressHUD
    [[SVProgressHUD sharedView] setTintColor:[UIColor blackColor]];
    [[SVProgressHUD sharedView] setBackgroundColor:[UIColor lighterGrayCustom]];
    
    FFEvent *eventNew = [FFEvent new];
    eventNew.stringCustomerName = searchBarCustom.stringClientName;
    eventNew.numCustomerID = searchBarCustom.numCustomerID;
    eventNew.dateDay = buttonDate.dateOfButton;
    eventNew.dateTimeBegin = buttonTimeBegin.dateOfButton;
    eventNew.dateTimeEnd = buttonTimeEnd.dateOfButton;
    eventNew.arrayWithGuests = tableViewGuests.arrayWithSelectedItens;
    eventNew.dataObject = event.dataObject;
    eventNew.delegate = event.delegate;
    event.dateDay = buttonDate.dateOfButton;
    event.dateTimeBegin = buttonTimeBegin.dateOfButton;
    event.dateTimeEnd = buttonTimeEnd.dateOfButton;
    
    NSString *stringError;
    
    if (!eventNew.numCustomerID) {
        stringError = @"Please select a customer.";
    } else if (![self isTimeBeginEarlier:eventNew.dateTimeBegin timeEnd:eventNew.dateTimeEnd]) {
        stringError = @"Start time must occur earlier than end time.";
    } else if (eventNew.arrayWithGuests.count == 0) {
        //        stringError = @"Please select a guest.";
    }
    
    if (stringError) {
        [SVProgressHUD showErrorWithStatus:stringError];
    } else if (protocol != nil && [protocol respondsToSelector:@selector(saveEvent:)]) {
        [[ITObjectCacher globalCache] storeObject:eventNew withKey:kCalendarEvent];
        [protocol saveEvent:eventNew];
        [self buttonDeleteAction:nil];
    }
}

- (BOOL)isTimeBeginEarlier:(NSDate *)dateBegin timeEnd:(NSDate *)dateEnd {
    
    BOOL boolIsRight = YES;
    
    NSDateComponents *compDateBegin = [NSDate componentsOfDate:dateBegin];
    NSDateComponents *compDateEnd = [NSDate componentsOfDate:dateEnd];
    
    if ((compDateBegin.hour > compDateEnd.hour) || (compDateBegin.hour == compDateEnd.hour && compDateBegin.minute >= compDateEnd.minute)) {
        boolIsRight = NO;
    }
    
    return boolIsRight;
}

- (IBAction)buttonDeleteAction:(id)sender {
    
    if (protocol != nil && [protocol respondsToSelector:@selector(deleteEvent:)]) {
        [[ITObjectCacher globalCache] storeObject:event withKey:kCalendarEvent];
        [protocol deleteEvent:event];
    }
    
    [self buttonCancelAction:nil];
}

#pragma mark - Tap Gesture

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    [searchBarCustom closeKeyboardAndTableView];
}

#pragma mark - Add Subviews

- (void)addButtonCancel {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, BUTTON_HEIGHT)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor lighterGrayCustom]];
    [self addSubview:view];
    
    buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [self customLayoutOfButton:buttonCancel withTitle:@"Annulla" action:@selector(buttonCancelAction:) frame:CGRectMake(20, 0, 80, BUTTON_HEIGHT)];
    [view addSubview:buttonCancel];
}

- (void)addButtonDone {
    
    buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDone setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self customLayoutOfButton:buttonDone withTitle:@"Fatto" action:@selector(buttonDoneAction:) frame:CGRectMake(buttonCancel.superview.frame.size.width-80-10, buttonCancel.frame.origin.y, 80, buttonCancel.frame.size.height)];
    [buttonCancel.superview addSubview:buttonDone];
}

- (void)addSearchBar {
    
    searchBarCustom = [[FFSearchBarWithAutoComplete alloc] initWithFrame:CGRectMake(0,buttonCancel.superview.frame.origin.y+buttonCancel.superview.frame.size.height+ BUTTON_HEIGHT, self.frame.size.width, BUTTON_HEIGHT)];
    [searchBarCustom setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [searchBarCustom setStringClientName:event.stringCustomerName];
    [searchBarCustom setNumCustomerID:event.numCustomerID];
    [self addSubview:searchBarCustom];
}

- (void)addButtonDate {
    
    buttonDate = [[FFButtonWithDatePopover alloc] initWithFrame:CGRectMake(0, searchBarCustom.frame.origin.y+searchBarCustom.frame.size.height+2, self.frame.size.width, BUTTON_HEIGHT) date:event.dateDay];
    [buttonDate setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:buttonDate];
}

- (void)addButtonTimeBegin {
    
    buttonTimeBegin = [[FFButtonWithHourPopover alloc] initWithFrame:CGRectMake(0, buttonDate.frame.origin.y+buttonDate.frame.size.height+BUTTON_HEIGHT, self.frame.size.width, BUTTON_HEIGHT) date:event.dateTimeBegin];
    [buttonTimeBegin setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:buttonTimeBegin];
}

- (void)addButtonTimeEnd {
    
    buttonTimeEnd = [[FFButtonWithHourPopover alloc] initWithFrame:CGRectMake(0, buttonTimeBegin.frame.origin.y+buttonTimeBegin.frame.size.height+2, self.frame.size.width, BUTTON_HEIGHT) date:event.dateTimeEnd];
    [buttonTimeEnd setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:buttonTimeEnd];
}

- (void)addButtonDelete {
    
    buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDelete setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self customLayoutOfButton:buttonDelete withTitle:@"Delete Event" action:@selector(buttonDeleteAction:) frame:CGRectMake(0, self.frame.size.height-1.2*BUTTON_HEIGHT, self.frame.size.width, 1.2*BUTTON_HEIGHT)];
    [buttonDelete setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:buttonDelete];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, buttonDelete.frame.origin.y-BUTTON_HEIGHT, self.frame.size.width, BUTTON_HEIGHT)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self addSubview:view];
}

- (void)addtableViewGuests {
    
    CGFloat y = buttonTimeEnd.frame.origin.y+buttonTimeEnd.frame.size.height+BUTTON_HEIGHT;
    
    tableViewGuests = [[FFGuestsTableView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width,buttonDelete.frame.origin.y-y-BUTTON_HEIGHT)];
    [tableViewGuests setAutoresizingMask:AR_WIDTH_HEIGHT];
    [tableViewGuests setArrayWithSelectedItens:event.arrayWithGuests];
    //    [self addSubview:tableViewGuests];
}

-(void)addEventTyeSegmentedControl {
    CGFloat y = buttonTimeEnd.frame.origin.y+buttonTimeEnd.frame.size.height+(BUTTON_HEIGHT/2);
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Telefonata",@"Visita",@"Email"]];
    [segmentedControl setFrame:CGRectMake(self.frame.size.width*0.1, y, self.frame.size.width*0.8,40)];
    [segmentedControl addTarget:self action:@selector(didSelectEventTypeFromSender:) forControlEvents:UIControlEventValueChanged];
    
    if (event.type>0 && [event.type integerValue] < segmentedControl.numberOfSegments)
        [segmentedControl setSelectedSegmentIndex:[event.type integerValue]];
    
    [self addSubview:segmentedControl];
}

#pragma mark - Button Layout

- (void)customLayoutOfButton:(UIButton *)button withTitle:(NSString *)title action:(SEL)action frame:(CGRect)frame {
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize]];
    [button setFrame:frame];
    [button setContentMode:UIViewContentModeScaleAspectFit];
}

#pragma mark - Segmented Control Action

-(void)didSelectEventTypeFromSender:(UISegmentedControl *)sender
{
    NSNumber *eventType = @(sender.selectedSegmentIndex);
    
    for (NSInteger currentType = FFEventTypeCall;currentType <= FFEventTypeVisit;currentType++)
        [AppointmentType findOrCreateWithValue:@(currentType) completionHandler:nil];
    
    event.type = eventType;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:self];
    
    return !(searchBarCustom.arrayOfTableView.count != 0 && CGRectContainsPoint(searchBarCustom.tableViewCustom.frame, point)) &&
    CGRectContainsPoint(tableViewGuests.frame, point) && searchBarCustom.tableViewCustom.superview;
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //Comment this line to don't update showed region with user's region
    //    MKCoordinateRegion mapRegion;
    //    mapRegion.center = mapView.userLocation.coordinate;
    //    mapRegion.span.latitudeDelta = 0.2;
    //    mapRegion.span.longitudeDelta = 0.2;
    //    [mapView setRegion:mapRegion animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mymapView viewForAnnotation:(id)annotation
{
    if (annotation == mymapView.userLocation)
    {
        return nil;
    }
    
    UIButton *collautButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    pin.pinColor = MKPinAnnotationColorRed;
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = collautButton;
    pin.animatesDrop = YES;
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annotationView in annotationViews)
    {
        // Don't pin drop if annotation is user location
        if ([annotationView.annotation isKindOfClass:[MKUserLocation class]])
        {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(annotationView.annotation.coordinate);
        if (!MKMapRectContainsPoint(mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = annotationView.frame;
        
        // Move annotation out of view
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - self.frame.size.height, annotationView.frame.size.width, annotationView.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[annotationViews indexOfObject:annotationView] options:UIViewAnimationCurveLinear animations:^{
            
            annotationView.frame = endFrame;
            // Animate squash
        }completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:0.05 animations:^{
                    annotationView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished)
                    {
                        [UIView animateWithDuration:0.1 animations:^{
                            annotationView.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKPinAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSDictionary *addressDict = @{
                                  (NSString *)kABPersonAddressCountryKey : @"IT",
                                  (NSString *)kABPersonAddressCityKey : customer.citta,
                                  (NSString *)kABPersonAddressStreetKey : customer.via,
                                  (NSString *)kABPersonAddressZIPKey : customer.cap,
                                  };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // switch to a background thread and perform your expensive operation
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // switch back to the main thread to update your UI
            
            ITLocationPlace *locationPlace = [[ITLocationPlace alloc] init];
            [locationPlace setCitta:customer.citta];
            [locationPlace setIndirizzo:customer.via];
            [locationPlace setStati:@"Italia"];
            [locationPlace setCap:customer.cap.codice];
            
            [[ITLocationBroker sharedBroker] geocodedCoordinatesFromLocaction:locationPlace withBlock:^(CLLocationCoordinate2D coordinates, NSError *message) {
                if (message)
                {
                    if ([message.domain isEqualToString:kCLErrorDomain])
                        [ITAlertView showErrorWithMessage:@"Impossibile localizzare il cliente!"];
                    else
                        [ITAlertView showErrorWithMessage:message.description];
                }
                else
                {
                    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinates addressDictionary:addressDict];
                    
                    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
                    BOOL isMapLoaded = [MKMapItem openMapsWithItems:@[mapItem] launchOptions:[NSDictionary dictionaryWithObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey]];
                    
                    if (!isMapLoaded)
                        [ITAlertView showErrorWithMessage:@"Non è stato possibile caricare le coordinate del cliente"];
                }
            }];
        });
    });
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //
}

@end
