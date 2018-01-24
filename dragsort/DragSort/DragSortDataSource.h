//
//  DragSortDataSource.h
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SortConfigInfo.h"

@interface DragSortDataSource : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 分类对象 */
@property (strong, nonatomic) SortConfigInfo *sortData;
/** cell是否处于编辑模式 */
@property (assign, nonatomic) BOOL cellEditMode;

@end
