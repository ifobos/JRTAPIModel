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

#import "JRTAPIModel.h"

@interface JRTAPIModel ()

@property (nonatomic, strong) AFHTTPSessionManager<Ignore> *manager;
@property (nonatomic, readonly) NSString *API_URL;

@end

@implementation JRTAPIModel



#pragma mark - Configuration


- (id<JRTAPIModelConfigurationDelegate>)configurationDelegate {
    if (!_configurationDelegate) {
        @throw  [[NSException alloc] initWithName:[NSString stringWithFormat:@"%@", self.class]
                                           reason:[NSString stringWithFormat:@"%@, It should not be empty. ", NSStringFromSelector(_cmd)]
                                         userInfo:nil];
    }
    return _configurationDelegate;
}

#pragma mark - Reachability

+ (void)startReachabilityMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)reachabilityStatusWithReachable:(void (^)())reachable
                           notReachable:(void (^)())notReachable {
    return [self reachabilityStatusWithNotReachable:notReachable
                                   reachableViaWiFi:reachable
                                   reachableViaWWAN:reachable];
}

+ (void)reachabilityStatusWithNotReachable:(void (^)())notReachable
                          reachableViaWiFi:(void (^)())reachableViaWiFi
                          reachableViaWWAN:(void (^)())reachableViaWWAN {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                notReachable();
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                reachableViaWiFi();
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                reachableViaWWAN();
                break;
            default:
                NSLog(@"Unkown network status");
                break;
        }
    }];
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        notReachable();
    }
    if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
        reachableViaWiFi();
    }
    if ([AFNetworkReachabilityManager sharedManager].reachableViaWWAN) {
        reachableViaWWAN();
    }
}

#pragma mark - Getters

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - Header Request

- (void)setHeaderParameters:(NSArray *)headers
       forRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
      andResponseSerializer:(AFHTTPResponseSerializer *)responseSerializer {
    if ([headers count] > 0) {
        for (int i = 0; i < [headers count]; i++) {
            NSDictionary *header = (NSDictionary *)[headers objectAtIndex:i];
            [requestSerializer setValue:[header objectForKey:@"value"]
                     forHTTPHeaderField:[header objectForKey:@"key"]];
        }
    }
    self.manager.requestSerializer = requestSerializer;
    self.manager.responseSerializer = responseSerializer;
}

#pragma mark - Request

- (void)executeRequestType:(JRTAPIModelRequestType)requestType
                  withPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(JRTObjectBlok)success
                   failure:(JRTErrorBlock)failure {
    switch (requestType) {
        case JRTAPIModelRequestTypeGet:
            [self getPath:path
                   params:params
                  success:success
                  failure:failure];
            break;
        case JRTAPIModelRequestTypeGetJson:
            [self getJsonForPath:path
                          params:params
                         success:success
                         failure:failure];
            break;
        case JRTAPIModelRequestTypePost:
            [self postPath:path
                    params:params
                   success:success
                   failure:failure];
            break;
        case JRTAPIModelRequestTypePostJson:
            [self postJsonForPath:path
                           params:params
                          success:success
                          failure:failure];
            break;
        case JRTAPIModelRequestTypePut:
            [self putPath:path
                   params:params
                  success:success
                  failure:failure];
            break;
        case JRTAPIModelRequestTypePutJson:
            [self putJsonForPath:path
                          params:params
                         success:success
                         failure:failure];
            break;
        case JRTAPIModelRequestTypeDelete:
            [self deletePath:path
                      params:params
                     success:success
                     failure:failure];
            break;
        case JRTAPIModelRequestTypeDeleteJson:
            [self deleteJsonPath:path
                          params:params
                         success:success
                         failure:failure];
            break;
        default:
            break;
    }
}

#pragma mark - GET

- (void)getPath:(NSString *)path
         params:(NSDictionary *)params
        success:(JRTObjectBlok)success
        failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypeGet
           requestSerializer:[AFHTTPRequestSerializer serializer]
          responseSerializer:[AFHTTPResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

- (void)getJsonForPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypeGetJson
           requestSerializer:[AFJSONRequestSerializer serializer]
          responseSerializer:[AFJSONResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

#pragma mark - POST

- (void)postPath:(NSString *)path
          params:(NSDictionary *)params
         success:(JRTObjectBlok)success
         failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypePost
           requestSerializer:[AFHTTPRequestSerializer serializer]
          responseSerializer:[AFHTTPResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

- (void)postJsonForPath:(NSString *)path
                 params:(NSDictionary *)params
                success:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypePostJson
           requestSerializer:[AFJSONRequestSerializer serializer]
          responseSerializer:[AFJSONResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

#pragma mark - PUT

- (void)putPath:(NSString *)path
         params:(NSDictionary *)params
        success:(JRTObjectBlok)success
        failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypePut
           requestSerializer:[AFHTTPRequestSerializer serializer]
          responseSerializer:[AFHTTPResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

- (void)putJsonForPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypePutJson
           requestSerializer:[AFJSONRequestSerializer serializer]
          responseSerializer:[AFJSONResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

#pragma mark - DELETE

- (void)deletePath:(NSString *)path
            params:(NSDictionary *)params
           success:(JRTObjectBlok)success
           failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypeDelete
           requestSerializer:[AFHTTPRequestSerializer serializer]
          responseSerializer:[AFHTTPResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

- (void)deleteJsonPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure {
    [self performRequestType:JRTAPIModelRequestTypeDeleteJson
           requestSerializer:[AFJSONRequestSerializer serializer]
          responseSerializer:[AFJSONResponseSerializer serializer]
                        path:path
                      params:params
                     success:success
                     failure:failure];
}

#pragma mark - Request

- (void)performRequestType:(JRTAPIModelRequestType)requestType
         requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
        responseSerializer:(AFHTTPResponseSerializer *)responseSerializer
                      path:(NSString *)path
                    params:(NSDictionary *)params
                   success:(JRTObjectBlok)success
                   failure:(JRTErrorBlock)failure {
    [self.configurationDelegate headerWithSuccess:^(NSArray *headers) {
        NSString *encodedPath = [self urlencode:path];
        [self setHeaderParameters:headers
             forRequestSerializer:requestSerializer
            andResponseSerializer:responseSerializer];
            
        NSString *url = [NSString stringWithFormat:@"%@/%@", [self.configurationDelegate API_URL], encodedPath];
        
        void (^requestSuccess) (NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) = ^void (NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            success(responseObject);
        };
        
        void (^requestFailure) (NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) = ^void (NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [self.configurationDelegate catchFailureOperation:task
                                                        error:error
                                                  requestType:requestType
                                                         path:path
                                                       params:params
                                                      success:success
                                                      failure:failure];
        };
        
        switch (requestType) {
            case JRTAPIModelRequestTypeGet:
            case JRTAPIModelRequestTypeGetJson:
                [self.manager GET:url
                       parameters:params
                         progress:nil
                          success:requestSuccess
                          failure:requestFailure];
                break;
            case JRTAPIModelRequestTypePost:
            case JRTAPIModelRequestTypePostJson:
                [self.manager POST:url
                        parameters:params
                          progress:nil
                           success:requestSuccess
                           failure:requestFailure];
                break;
            case JRTAPIModelRequestTypePut:
            case JRTAPIModelRequestTypePutJson:
                [self.manager PUT:url
                       parameters:params
                          success:requestSuccess
                          failure:requestFailure];
                break;
            case JRTAPIModelRequestTypeDelete:
            case JRTAPIModelRequestTypeDeleteJson:
                [self.manager DELETE:url
                          parameters:params
                             success:requestSuccess
                             failure:requestFailure];
                break;
            default:
                break;
        }
    }
                                          failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - helper

- (NSString *)urlencode:(NSString *)url {
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedUrl;
}

@end
