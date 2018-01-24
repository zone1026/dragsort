//
//  SortDataManager.h
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DragSortManager : NSObject

/** 单例 */
+ (instancetype)sharedManager;
/**
 * @description 打开拖拽分类视图
 * @param sortIdentify 分类标识
 * @param sortList 分类信息列表，可为空
 */
- (void)openDragSortView:(NSString *)sortIdentify withSortDataSource:(NSArray *)sortList;

@end
