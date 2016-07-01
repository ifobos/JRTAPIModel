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

#import "JSONModel/JSONModel.h"
#import "AFHTTPSessionManager.h"

#pragma mark - typedef

typedef void (^JRTObjectBlok)(id data);
typedef void (^JRTErrorBlock)(NSError *error);

#pragma mark - Request Type

/*!
   JRTRequestType lists the different types of available request.
 */
typedef NS_ENUM (NSInteger, JRTAPIModelRequestType) {
    /*!
       Specifies the type of request GET.
     */
    JRTAPIModelRequestTypeGet,
    /*!
       specifies the type of GET request that returns a JSON.
     */
    JRTAPIModelRequestTypeGetJson,
    /*!
       Specifies the type of request POST.
     */
    JRTAPIModelRequestTypePost,
    /*!
       specifies the type of POST request that returns a JSON.
     */
    JRTAPIModelRequestTypePostJson,
    /*!
       Specifies the type of request PUT.
     */
    JRTAPIModelRequestTypePut,
    /*!
       specifies the type of PUT request that returns a JSON.
     */
    JRTAPIModelRequestTypePutJson,
    /*!
       Specifies the type of request DELETE.
     */
    JRTAPIModelRequestTypeDelete,
    /*!
       specifies the type of DELETE request that returns a JSON.
     */
    JRTAPIModelRequestTypeDeleteJson
};

#pragma mark - Configuration

@protocol JRTAPIModelConfigurationDelegate <NSObject>

/*!
   This is a configuration method that must be implemented in a subclass. This method
   should return a string that contains the base address of the API.
   
   @code
   - (NSString *)API_URL {
   return @"https://myapi.com/v1";
   }
   @endcode
 */
- (NSString *)API_URL;

/*!
   This is a configuration method that must be implemented in a subclass. This method
   can define the header of each request to make, this is useful for example when a
   token authentication is implemented.
   
   @param successHeader block receives an array of dictionaries making the
   key-value of each element be added to the header, this block can receive nil.
   @param failure       this block must be executed in the event of an error, one
   receives as pararametro NSError execute this block will stop the request.
   
   @code
   - (void)headerWithSuccess:(void (^)(NSArray *headers))successHeader failure:(void (^)(NSError *error))failure {
   NSMutableArray *result      = [NSMutableArray new];
   ModelUser *currentUser      = [ModelUser currentUser];
   if (currentUser.userToken) {
   [result addObject:@{ @"key": @"Authorization", @"value": currentUser.userToken }];
   }
   successHeader(result);
   }
   @endcode
 */
- (void)headerWithSuccess:(void (^)(NSArray *headers))successHeader
                  failure:(void (^)(NSError *error))failure;
                  
/*!
   This method should be implemented in a subclass. This method is executed every you see a
   request returns an error. this is useful for example when a token authentication is expired
   
   @param operation   is a NSURLSessionTask, is returned by the method AFNetworking.
   @param error       is a NSError is returned by the method AFNetworking.
   @param requestType is a JRTRequestType, specifies the type of request.
   @param path        parameter that was sent to make the request.
   @param params      parameter that was sent to make the request.
   @param success     parameter that was sent to make the request.
   @param failure     parameter that was sent to make the request.
   
   @code
   - (void)catchFailureOperation:(NSURLSessionTask *)operation
   error:(NSError *)error
   requestType:(JRTRequestType)requestType
   path:(NSString *)path
   params:(NSDictionary *)params
   success:(JRTObjectBlok)success
   failure:(JRTErrorBlock)failure {
   if (error.code == 401) {
   //Refres Autorization Success
   [self executeRequestType:requestType
   withPath:path
   params:params
   success:success
   failure:failure];
   }
   else {
   failure(error);
   }
   }
   @endcode
 */
- (void)catchFailureOperation:(NSURLSessionTask *)operation
                        error:(NSError *)error
                     userInfo:(id)userInfo
                  requestType:(JRTAPIModelRequestType)requestType
                         path:(NSString *)path
                       params:(NSDictionary *)params
                      success:(JRTObjectBlok)success
                      failure:(JRTErrorBlock)failure;
                      
                      
                      
@end

/*!
   JRTAPIModel possessing the most common implementation of AFNetworking within
   a subclass of JSONModel, this so to you make a sub-class JRTAPIModel only
   necessary to specify the setting methods for connecting to the API. one you
   see done, all subclasses inherit the configuration and therefore only for
   lack JSONModel you implement each of your models, and consume the methods
   for different request.
   
   @code
   // Most basic implementation
   
   #pragma mark - Configuration
   
   - (NSString *)API_URL {
    return @"https://myapi.com/v1";
   }
   
   - (void)headerWithSuccess:(void (^)(NSArray *headers))successHeader
                   failure:(void (^)(NSError *error))failure {
    successHeader(nil);
   }
   
   - (void)catchFailureOperation:(NSURLSessionTask *)operation
                         error:(NSError *)error
                   requestType:(JRTRequestType)requestType
                          path:(NSString *)path
                        params:(NSDictionary *)params
                       success:(JRTObjectBlok)success
                       failure:(JRTErrorBlock)failure {
     failure(error);
   }
   @endcode
 */
@interface JRTAPIModel : JSONModel

@property (weak, nonatomic) id<JRTAPIModelConfigurationDelegate, Ignore> configurationDelegate;

#pragma mark - Reachability

/*!
   It's a method that starts monitoring the network, it is more appropriate to run
   inside the `AppDelegate` class in the` didFinishLaunchingWithOptions`.
   
   @code
   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     ...
     
    [JRTAPIModel startReachabilityMonitoring];
    
    return YES;
   }
   @endcode
 */
+ (void)startReachabilityMonitoring;

/*!
   Method that executes the corresponding block to changes in state of the connection
   to the network. These methods are executed at the time of the call to this method.
   
   @param reachable    block is executed when the network is available.
   @param notReachable block is executed when the network is not available.
 */
+ (void)reachabilityStatusWithReachable:(void (^)())reachable
                           notReachable:(void (^)())notReachable;
                           
                           
/*!
   Method that executes the corresponding block to changes in state of the connection
   to the network, differentiating the connection mode. These methods are executed at
   the time of the call to this method.
   
   
   @param notReachable     block is executed when the network is not available.
   @param reachableViaWiFi block is executed when the network is available via Wifi.
   @param reachableViaWWAN block is executed when the network is available via WWAN.
 */
+ (void)reachabilityStatusWithNotReachable:(void (^)())notReachable
                          reachableViaWiFi:(void (^)())reachableViaWiFi
                          reachableViaWWAN:(void (^)())reachableViaWWAN;
                          
#pragma mark - Generic Request

/*!
   This method is made to execute any request methods. defined JRTRequestType.
   
   @param requestType requestType is a JRTRequestType, specifies the type of request.
   @param path        is the string to be concatenated to the url API base to form the full
                    URL where it will be made on request.
   @param params      it is a dictionary containing the parameters that are attached request.
   @param success     is the block that is executed when the request is made successfully.
                    Receives as a parameter the object returned by the request.
   @param failure     is the block that is executed when the request has failed.
                    Receives as a parameter the error returned by the request.
 */
- (void)executeRequestType:(JRTAPIModelRequestType)requestType
                  withPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(JRTObjectBlok)success
                   failure:(JRTErrorBlock)failure;
                   
#pragma mark - GET

/*!
   This method performs a GET request to the API set.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)getPath:(NSString *)path
         params:(NSDictionary *)params
        success:(JRTObjectBlok)success
        failure:(JRTErrorBlock)failure;
        
/*!
   This method performs a GET request to the API set, use this method when the response is a JSON.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)getJsonForPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure;
               
#pragma mark - POST

/*!
   This method performs a POST request to the API set.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)postPath:(NSString *)path
          params:(NSDictionary *)params
         success:(JRTObjectBlok)success
         failure:(JRTErrorBlock)failure;
         
/*!
   This method performs a POST request to the API set, use this method when the response is a JSON.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)postJsonForPath:(NSString *)path
                 params:(NSDictionary *)params
                success:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure;
                
#pragma mark - PUT

/*!
   This method performs a PUT request to the API set.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)putPath:(NSString *)path
         params:(NSDictionary *)params
        success:(JRTObjectBlok)success
        failure:(JRTErrorBlock)failure;
        
/*!
   This method performs a PUT request to the API set, use this method when the response is a JSON.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)putJsonForPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure;
               
#pragma mark - DELETE

/*!
   This method performs a DELETE request to the API set.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)deletePath:(NSString *)path
            params:(NSDictionary *)params
           success:(JRTObjectBlok)success
           failure:(JRTErrorBlock)failure;
           
/*!
   This method performs a DELETE request to the API set, use this method when the response is a JSON.
   
   @param path    is the string to be concatenated to the url API base to form the full
                URL where it will be made on request.
   @param params  it is a dictionary containing the parameters that are attached request.
   @param success is the block that is executed when the request is made successfully.
                Receives as a parameter the object returned by the request.
   @param failure is the block that is executed when the request has failed.
                Receives as a parameter the error returned by the request.
 */
- (void)deleteJsonPath:(NSString *)path
                params:(NSDictionary *)params
               success:(JRTObjectBlok)success
               failure:(JRTErrorBlock)failure;
               
               
@end
