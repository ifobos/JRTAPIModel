//
//  PostModel.m
//  JRTAPIModel
//
//  Created by Juan Garcia on 1/19/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id": @"uid" }];
}

- (void)GETpostsSuccess:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure {
    [self getJsonForPath:@"posts"
                  params:@{}
                 success:^(id data) {
        NSError *error;
        NSArray *result = [PostModel arrayOfModelsFromDictionaries:data error:&error];
        success(result);
    }
                 failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)GETpostOneSuccess:(JRTObjectBlok)success
                  failure:(JRTErrorBlock)failure {
    [self getJsonForPath:@"posts/1"
                  params:@{}
                 success:^(id data) {
        NSError *error;
        PostModel *result = [[PostModel alloc] initWithDictionary:data error:&error];
        success(result);
    }
                 failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)POSTpostSuccess:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure {
    [self postJsonForPath:@"posts"
                   params:@{ @"title": @"foo", @"body": @"bar", @"userId": @1 }
                  success:^(id data) {
        NSError *error;
        PostModel *result = [[PostModel alloc] initWithDictionary:data error:&error];
        success(result);
    }
                  failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)PUTpostOneSuccess:(JRTObjectBlok)success
                  failure:(JRTErrorBlock)failure {
    [self putJsonForPath:@"posts/1"
                  params:@{ @"id": @1, @"title": @"foo", @"body": @"bar", @"userId": @1 }
                 success:^(id data) {
        NSError *error;
        PostModel *result = [[PostModel alloc] initWithDictionary:data error:&error];
        success(result);
    }
                 failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)DELETEpostOneSuccess:(JRTObjectBlok)success
                     failure:(JRTErrorBlock)failure {
    [self deleteJsonPath:@"posts/1"
                  params:@{}
                 success:^(id data) {
        success(data);
    }
                 failure:^(NSError *error) {
        failure(error);
    }];
}

@end
