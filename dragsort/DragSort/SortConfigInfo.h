//
//  SortConfigInfo.h
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 分类视图标签数据
 */
@interface SortTagData : NSObject
/** tag的描述*/
@property (copy, nonatomic) NSString *desc;
/** 是否是固定不动的 */
@property (assign, nonatomic) BOOL fixed;
/** tag所承载的数据（比如：标签ID） */
@property (strong, nonatomic) id data;

@end

/**
 * 分类视图所用的配置数据
 */
@interface SortConfigInfo : NSObject

///////////////////////// 已选类别配置信息 /////////////////////////
/** 已选类别中的标题*/
@property (copy, nonatomic) NSString *selectedTitle;
/** 已选类别中的辅助描述*/
@property (copy, nonatomic) NSString *selectedDesc;
/** 已选类别中的编辑模式下的辅助描述*/
@property (copy, nonatomic) NSString *selectedDescForEditMode;
/** 已选类别中的分类数组 */
@property (strong, nonatomic) NSMutableArray <SortTagData *> *selectedSortArr;
/** 已选类别中的在分类列表中的索引 */
@property (assign, nonatomic) NSInteger selectedIndex;

///////////////////////// 待选类别配置信息 /////////////////////////
/** 待选池中的标题*/
@property (copy, nonatomic) NSString *pondTitle;
/** 待选池中的辅助描述*/
@property (copy, nonatomic) NSString *pondDesc;
/** 待选池中的分类数组 */
@property (strong, nonatomic) NSMutableArray <SortTagData *> *pondSortArr;

/**
 * @description 配置分类视图所用的数据
 */
- (void)configSortData;

/** 获取已经选择的tag个数 */
- (NSInteger)getSelectedSortNum;

/** 获取还在待选池中的tag个数 */
- (NSInteger)getPondSortNum;

@end
