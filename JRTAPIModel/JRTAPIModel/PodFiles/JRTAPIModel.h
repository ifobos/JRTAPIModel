//Copyright (c) 2015 Juan Carlos Garcia Alfaro. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

//This is an Alpha Version, Updating for AFNetworking 3.0.4

#import "JSONModel/JSONModel.h"
#import "AFHTTPSessionManager.h"

#pragma mark - Constants
extern NSString * const kAPI_URL;
extern NSString * const kImageURL;

#pragma mark - typedef
typedef void(^JRTObjectBlok)(id data);
typedef void(^JRTErrorBlock)(NSError *error);
typedef enum
{
    JRTRequestTypeGet,
    JRTRequestTypePost,
    JRTRequestTypePostJson,
    JRTRequestTypePut,
    JRTRequestTypePutJson,
    JRTRequestTypeDelete
} JRTRequestType;

@interface JRTAPIModel : JSONModel

@property (nonatomic, readonly) NSString *API_URL;

+ (void)startReachabilityMonitoring;

+ (void)reachabilityStatusWithReachable:(void (^)())reachable
                           notReachable:(void (^)())notReachable;

+ (void)reachabilityStatusWithNotReachable:(void (^)())notReachable
                          reachableViaWiFi:(void (^)())reachableViaWiFi
                          reachableViaWWAN:(void (^)())reachableViaWWAN;


- (void)headerWithSuccess:(void (^)(NSArray *headers))successHeader
                  failure:(void (^)(NSError *error))failure;

- (void)executeRequestType:(JRTRequestType)requestType
                  withPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(JRTObjectBlok)success
                   failure:(JRTErrorBlock)failure;

- (void)getPath:(NSString *)path
         params:(NSDictionary *)params
        success:(JRTObjectBlok)success
        failure:(JRTErrorBlock)failure;

- (void)postPath:(NSString *)path
          params:(NSDictionary *)params
         success:(JRTObjectBlok)success
         failure:(JRTErrorBlock)failure;

- (void)postJsonForPath:(NSString *)path
                 params:(NSDictionary *)params
                success:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure;

- (void)putPath:(NSString *)path
         params:(NSDictionary *)params
        success:(JRTObjectBlok)success
        failure:(JRTErrorBlock)failure;

- (void)putJsonForPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure;

- (void)deletePath:(NSString *)path
            params:(NSDictionary *)params
           success:(JRTObjectBlok)success
           failure:(JRTErrorBlock)failure;


@end
