//
//  PostModel.h
//  JRTAPIModel
//
//  Created by Juan Garcia on 1/19/16.
//  Copyright © 2016 jerti. All rights reserved.
//

#import "DemoAPIModel.h"

@interface PostModel : DemoAPIModel
@property (nonatomic) NSInteger Id;
@property (nonatomic) NSInteger userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;


- (void)GETpostsSuccess:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure;

- (void)GETpostOneSuccess:(JRTObjectBlok)success
                  failure:(JRTErrorBlock)failure;

- (void)POSTpostSuccess:(JRTObjectBlok)success
                failure:(JRTErrorBlock)failure;

- (void)PUTpostOneSuccess:(JRTObjectBlok)success
                  failure:(JRTErrorBlock)failure;

- (void)DELETEpostOneSuccess:(JRTObjectBlok)success
                     failure:(JRTErrorBlock)failure;

@end
