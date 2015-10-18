//
//  Global.h
//  TainanDigLoad
//
//  Created by Geosat-RD01 on 2015/3/27.
//  Copyright (c) 2015年 Geosat-RD01. All rights reserved.
//

#import<netdb.h>
#import<arpa/inet.h>
#import<netinet/in.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import<SystemConfiguration/SystemConfiguration.h>

@interface Global : NSObject 



+(Global *)shareGlobal;
+(NSMutableArray *)setData:(NSMutableArray *)array;

+(CLLocationManager *)initLocationManager;

+(NSData*)getReturnDataByPostString:(NSString*)postString URL:(NSString*)url_address;

+(NSData *)getReturnDataByGetUrl:(NSString *) url_address;

+(void)searchDistrictByLat:(NSString *)lat andLon:(NSString *)lon;
+(void)startProgressDialog:(UIView *)view andX:(int)x andY:(int)y;
+(void)stopProgressDialog;
+(void)setReportDataByType:(NSString *)type;
+(int)getMaxValueByArray:(NSMutableArray *)array;
+ (UIImage*)resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)rotateImage:(UIImage *)aImage;
+ (BOOL)isConnected;
+(void) startProgressHUD:(UIView *)view andMessage:(NSString *)str;
+(void) stopProgressHUD;
@end
