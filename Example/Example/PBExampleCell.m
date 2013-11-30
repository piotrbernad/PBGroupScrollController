//
//  PBExampleCell.m
//  Example
//
//  Created by Piotr Bernad on 30.11.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import "PBExampleCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PBExampleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _imageView = [[UIImageView alloc] init];
        [_imageView.layer setOpacity:0.3];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setNumberOfLines:3];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    [_imageView setFrame:rect];
    [_titleLabel setFrame:CGRectInset(rect, 20.0f, 10.0f)];
}

@end
