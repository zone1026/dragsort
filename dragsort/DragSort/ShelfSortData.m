//
//  ShelfSortData.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "ShelfSortData.h"

@interface ShelfSortData ()
/** 书册Tag列表 */
@property (strong, nonatomic) NSArray *shelfArr;

@end

@implementation ShelfSortData

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)configSortData {
    [super configSortData];
    self.selectedTitle = @"我的书册";
    self.selectedDesc = @"点击进入书册";
    self.selectedIndex = 0;
    
    self.pondTitle = @"书册推荐";
    self.pondDesc = @"点击添加书册";
    
    [self configSortLiteData];
}

/** 配置书架分类列表数据 */
- (void)configSortLiteData {
    self.shelfArr = @[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"腾讯NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座"
                      ,@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财",@"凑数0",@"凑数1",@"凑数2"
                      ,@"凑数3",@"凑数4",@"凑数5",@"凑数6",@"凑数7",@"凑数8",@"凑数9",@"凑数10",@"凑数11",@"凑数12",@"凑数13",@"凑数14",@"凑数15"
                      ,@"凑数16",@"凑数17",@"凑数18",@"凑数19",@"凑数20",@"凑数21",@"凑数22",@"凑数23",@"凑数24",@"凑数25",@"凑数26",@"凑数27",@"凑数28"];
    NSInteger shelfCount = self.shelfArr.count;
    for (NSInteger i = 0 ; i < shelfCount ; i++) {
        SortTagData *tagData = [[SortTagData alloc] init];
        tagData.desc = [self.shelfArr objectAtIndex:i];
        tagData.data = @(i);
        tagData.fixed = NO;
        if (i < ceilf(shelfCount*0.2)) {//已经选择的
            if (i == 0 || i == 1)
                tagData.fixed = YES;
            [self.selectedSortArr addObject:tagData];
        }
        else
            [self.pondSortArr addObject:tagData];
    }
}

@end
