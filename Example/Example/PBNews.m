//
//  PBNews.m
//  Example
//
//  Created by Piotr Bernad on 30.11.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import "PBNews.h"

@implementation PBNews

+ (instancetype)newsWithTitle:(NSString *)title{
    PBNews *_news = [[self alloc] init];
    [_news setTitle:title];
    return _news;
}

+(NSArray *)exampleNews {
    return @[[self newsWithTitle:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Proin vitae sem ut neque euismod pharetra nec sit amet sapien. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Morbi laoreet odio ut odio pharetra, sed cursus massa sagittis. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Quisque consequat erat eu nulla ultricies commodo. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Nunc ultrices enim at erat aliquam, a pellentesque neque interdum"],
             [self newsWithTitle:@"Mauris id erat lacinia, sodales diam sed, malesuada lectus Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Donec egestas elit sit amet molestie interdum. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Proin vitae sem ut neque euismod pharetra nec sit amet sapien. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Morbi laoreet odio ut odio pharetra, sed cursus massa sagittis Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Quisque consequat erat eu nulla ultricies commodo Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Quisque a metus non nibh convallis molestie Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Mauris id erat lacinia, sodales diam sed, malesuada lectus Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Sed mattis odio vitae velit elementum, non tempor urna faucibus. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Proin vitae sem ut neque euismod pharetra nec sit amet sapien. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Morbi laoreet odio ut odio pharetra, sed cursus massa sagittis Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Quisque consequat erat eu nulla ultricies commodo Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Nunc ultrices enim at erat aliquam, a pellentesque neque interdum Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Mauris id erat lacinia, sodales diam sed, malesuada lectus Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Sed mattis odio vitae velit elementum, non tempor urna faucibus. Mauris id erat lacinia, sodales diam sed."],
             [self newsWithTitle:@"Nulla laoreet dui vel mauris volutpat consectetu Mauris id erat lacinia, sodales diam sed."]];
}

@end
