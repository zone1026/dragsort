//
//  SortConfigInfo.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "SortConfigInfo.h"

@implementation SortTagData

@end

@implementation SortConfigInfo

- (id)init {
    if (self = [super init]) {
        _selectedTitle = @"我的选择";
        _selectedDesc = @"点击进入选择";
        _selectedDescForEditMode = @"拖拽可以排序";
        _selectedIndex = 0;
        
        _pondTitle = @"选择推荐";
        _pondDesc = @"点击添加推荐";
        
        [self configSortData];
    }
    return self;
}

- (NSMutableArray <SortTagData *> *)selectedSortArr {
    if (nil == _selectedSortArr)
        _selectedSortArr = [NSMutableArray array];
    return _selectedSortArr;
}

- (NSMutableArray <SortTagData *>*)pondSortArr {
    if (nil == _pondSortArr)
        _pondSortArr = [NSMutableArray array];
    return _pondSortArr;
}

- (void)configSortData {}

- (NSInteger)getSelectedSortNum {
   return self.selectedSortArr.count;
}

- (NSInteger)getPondSortNum {
   return self.pondSortArr.count;
}

@end
