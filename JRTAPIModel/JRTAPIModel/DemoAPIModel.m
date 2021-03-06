//
//  PostAPIModel.m
//  JRTAPIModel
//
//  Created by Juan Garcia on 1/19/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import "DemoAPIModel.h"

@implementation DemoAPIModel

- (instancetype)init {
    if (self = [super init]) {
        self.configurationDelegate = self;
    }
    return self;
}

#pragma mark - Implement


- (void)headerWithSuccess:(void (^)(NSArray *headers))successHeader
                  failure:(void (^)(NSError *error))failure {
    successHeader(nil);
}

- (NSString *)API_URL {
    return @"http://jsonplaceholder.typicode.com";
}

- (void)catchFailureOperation:(NSURLSessionTask *)operation
                        error:(NSError *)error
                     userInfo:(id)userInfo
                  requestType:(JRTAPIModelRequestType)requestType
                         path:(NSString *)path
                       params:(NSDictionary *)params
                      success:(JRTObjectBlok)success
                      failure:(JRTErrorBlock)failure {
    failure(error);
}

@end
