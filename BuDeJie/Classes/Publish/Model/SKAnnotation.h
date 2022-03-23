//
//  SKAnnotation.h
//  BuDeJie
//
//  Created by hongchen li on 2022/3/18.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SKAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy, nullable) NSString *title;
@property (nonatomic,copy, nullable) NSString *subtitle;
@end

NS_ASSUME_NONNULL_END
