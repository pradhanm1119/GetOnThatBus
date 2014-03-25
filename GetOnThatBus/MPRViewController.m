//
//  MPRViewController.m
//  GetOnThatBus
//
//  Created by Manas Pradhan on 3/25/14.
//  Copyright (c) 2014 Manas Pradhan. All rights reserved.
//

#import "MPRViewController.h"
#import <MapKit/MapKit.h>

@interface MPRViewController () <MKMapViewDelegate>
{
    NSDictionary       *myMapDictionary;
    NSArray            *myTransitStops;
}
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@end

@implementation MPRViewController

- (void)viewDidLoad
{
    NSURL *mapURL = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *mapURLRequest = [NSURLRequest requestWithURL:mapURL];
    
    [super viewDidLoad];
    
    [NSURLConnection sendAsynchronousRequest:mapURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        myMapDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        myTransitStops = myMapDictionary[@"row"];
        NSLog(@"%@", myTransitStops);
        
        for (NSDictionary *stop in myTransitStops)
        {
            double latitude = [stop[@"latitude"]doubleValue];
            double longitude = [stop[@"longitude"]doubleValue];
            
            CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.4, 1.0);
            MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = centerCoordinate;
            
            annotation.title = stop[@"cta_stop_name"];
            annotation.subtitle = stop[@"routes"];
            NSLog(@"Title %@", annotation.title);
            self.myMapView.region = region;
            [self.myMapView addAnnotation:annotation];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    
    // Set pin image attributes
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"Chicago-1"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}
@end
