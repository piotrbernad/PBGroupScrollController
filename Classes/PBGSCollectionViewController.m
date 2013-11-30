//
//  GSCollectionViewController.m
//  GroupedScrollController
//
//  Created by Piotr Bernad on 08.10.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import "PBGSCollectionViewController.h"
#import "PBGSViewController.h"


@implementation PBGSCollectionViewController {    
    NSInteger _beforeChangeIndex;
    NSInteger _itemsPerPage;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super init];
    if (self) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_collectionView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 0;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setScrollEnabled:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_collectionView setFrame:self.view.bounds];
}

- (NSArray *)visibleItems {
    return [self.scollDataSource itemsForPage:_currentPage];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/[collectionView numberOfItemsInSection:0]);
}

- (BOOL)parentViewControllerWantsItemsForward:(BOOL)forward {
    _beforeChangeIndex = _currentPage;
    switch (forward) {
        case YES:
            if ([self.scollDataSource numberOfItemsForPageAtIndex:_currentPage + 1] > 0) {
                _currentPage++;
                [self.collectionView reloadData];
                break;
            } else {
                return NO;
            }
        case NO:
            if (_currentPage - 1 >= 0) {
                _currentPage--;
                break;
            } else {
                return NO;
            }
    }
    return YES;
}

- (void)parentViewControllerWantsRollBack {
    _currentPage = _beforeChangeIndex;
    [self.collectionView reloadData];
}

- (void)parentViewControllerDidFinishAnimatingForward:(BOOL)forward {
    if (forward == NO) {
        [self.collectionView reloadData];
    }
}

- (void)parentViewControllerDidEndPullToRefresh {
    [self.collectionView reloadData];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self.collectionView reloadData];
}

@end
