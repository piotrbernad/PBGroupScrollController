//
//  PBExampleViewController.m
//  Example
//
//  Created by Piotr Bernad on 30.11.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import "PBExampleViewController.h"
#import "PBExampleCell.h"
#import "PBNews.h"

static NSString *kCellIdentifier = @"CellIdentifier";

@implementation PBExampleViewController {
    NSArray *_news;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOfItemsPerPage = 8;
    [self.collectionViewController.collectionView registerClass:[PBExampleCell class] forCellWithReuseIdentifier:kCellIdentifier];
    _news = [PBNews exampleNews];
}

#pragma mark - UICollectionView Data Source and Delegate

- (PBExampleCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PBExampleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    PBNews *news = [[self.collectionViewController visibleItems] objectAtIndex:indexPath.row];
    [cell.titleLabel setText:news.title];
    float index = indexPath.row + 1;
    float colorAlpha = 1 / index;
    [cell setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:colorAlpha]];
    return cell;
}

#pragma PBGSDataSource

- (NSArray *)itemsForPage:(NSInteger)page {
    NSRange rangeForPage = NSMakeRange(page * self.numberOfItemsPerPage, [self numberOfItemsForPageAtIndex:page]);
    return [_news objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeForPage]];
}

- (NSInteger)numberOfItemsForPageAtIndex:(NSInteger)pageNumber {
    NSInteger position = (pageNumber + 1) * self.numberOfItemsPerPage;
    return [_news count]  > position ? self.numberOfItemsPerPage : [_news count] - pageNumber * self.numberOfItemsPerPage;
}


@end
