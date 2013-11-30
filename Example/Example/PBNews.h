//
//  PBNews.h
//  Example
//
//  Created by Piotr Bernad on 30.11.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBNews : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
+ (instancetype)newsWithTitle:(NSString *)title;
+ (NSArray *)exampleNews;

@end
