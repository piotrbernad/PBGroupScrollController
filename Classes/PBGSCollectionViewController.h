//
//  GSCollectionViewController.h
//  GroupedScrollController
//
//  Created by Piotr Bernad on 08.10.2013.
//  Copyright (c) 2013 Piotr Bernad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBGSDataSource <NSObject>
@required
- (NSInteger)numberOfItemsForPageAtIndex:(NSInteger)pageNumber;
- (NSArray *)itemsForPage:(NSInteger)page;
@end

@interface PBGSCollectionViewController : UIViewController 

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *items;
@property (readonly, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) id<PBGSDataSource> scollDataSource;

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;
- (NSArray *)visibleItems;
- (BOOL)parentViewControllerWantsItemsForward:(BOOL)forward;
- (void)parentViewControllerWantsRollBack;
- (void)parentViewControllerDidFinishAnimatingForward:(BOOL)forward;
- (void)setItems:(NSArray *)items;

@end
