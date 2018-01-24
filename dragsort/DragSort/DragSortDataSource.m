//
//  DragSortDataSource.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "DragSortDataSource.h"
#import "SortTagCell.h"
#import "SortConfigInfo.h"
#import "SortHeaderReusableView.h"

static const CGFloat tagCellWidth = 90.0f;

@interface DragSortDataSource ()

@end

@implementation DragSortDataSource

- (id)init {
    if (self = [super init]) {
        self.cellEditMode = NO;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.sortData != nil)
            return [self.sortData getSelectedSortNum];
    }
    else if (section == 1) {
        if (self.sortData != nil)
            return [self.sortData getPondSortNum];
    }
        
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SortTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sortCell" forIndexPath:indexPath];
    SortTagData *data;
    if (indexPath.section == 0) {
        if (indexPath.item < [self.sortData getSelectedSortNum])
            data = [self.sortData.selectedSortArr objectAtIndex:indexPath.item];
    }
    else if (indexPath.section == 1) {
        if (indexPath.item < [self.sortData getPondSortNum])
            data = [self.sortData.pondSortArr objectAtIndex:indexPath.item];
    }
    [cell updateInfo:data withSelected:indexPath.section == 0 withEditMode:self.cellEditMode
                            withCurrentSelectedIndex:self.sortData.selectedIndex == indexPath.item];
    cell.hidden = NO;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] == NO)
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sortFooter" forIndexPath:indexPath];
    
    SortHeaderReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"sortHeader" forIndexPath:indexPath];
    if (indexPath.section == 0)
        [headView updateInfo:self.sortData.selectedTitle withDesc:(self.cellEditMode == YES ? self.sortData.selectedDescForEditMode :
         self.sortData.selectedDesc) withHideBtn:NO withEditMode:self.cellEditMode];
    else if (indexPath.section == 1)
             [headView updateInfo:self.sortData.pondTitle withDesc:self.sortData.pondDesc withHideBtn:YES
                     withEditMode:NO];
    return headView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (nil == self.sortData)
        return;
    SortTagData *cellData;
    NSIndexPath *toIndexPath;
    if (0 == indexPath.section) {
        if (self.cellEditMode == NO) {
            if (self.sortData.selectedIndex != indexPath.item) {
                NSMutableArray *indexPathArr = [NSMutableArray array];
                [indexPathArr addObject:[NSIndexPath indexPathForItem:self.sortData.selectedIndex inSection:0]];
                [indexPathArr addObject:indexPath];
                self.sortData.selectedIndex = indexPath.item;
                [collectionView reloadItemsAtIndexPaths:indexPathArr];
            }
            return;//非编辑模式下点击cell后跳转到已选中的tag
        }
        
        if ([collectionView numberOfItemsInSection:0] < 2)//少于两个的时候不可删除
            return;
        cellData = [self.sortData.selectedSortArr objectAtIndex:indexPath.item];
        if (nil == cellData || cellData.fixed == YES) //数据为空或者是固定不动的
            return;
        [self.sortData.selectedSortArr removeObject:cellData];
        [self.sortData.pondSortArr insertObject:cellData atIndex:0];
        toIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        if (self.sortData.selectedIndex == indexPath.item)
            self.sortData.selectedIndex = 0;
        else if (self.sortData.selectedIndex > indexPath.item)
            self.sortData.selectedIndex --;
    }
    else {
        cellData = [self.sortData.pondSortArr objectAtIndex:indexPath.item];
        [self.sortData.pondSortArr removeObject:cellData];
        [self.sortData.selectedSortArr addObject:cellData];
        toIndexPath = [NSIndexPath indexPathForItem:self.sortData.selectedSortArr.count - 1 inSection:0];
    }
    
    [collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    [collectionView reloadItemsAtIndexPaths:@[toIndexPath]];
    if (0 != indexPath.section && [self.sortData getPondSortNum] <= 0) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        [indexSet addIndex:indexPath.section];
        [collectionView reloadSections:indexSet];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                                            minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                                            minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                                                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(tagCellWidth, 50.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                                                referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 50.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                                                referenceSizeForFooterInSection:(NSInteger)section {
    if ((section == collectionView.numberOfSections - 1) && [self.sortData getPondSortNum] > 0)
        return CGSizeMake(collectionView.frame.size.width,120.0f);
    return CGSizeMake(collectionView.frame.size.width,0.01f);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.bounces = scrollView.contentOffset.y > 0;
//    if (scrollView.contentOffset.y < 0)
//        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0.0f);
}

@end
