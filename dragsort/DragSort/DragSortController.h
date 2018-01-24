//
//  DragSortController.h
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortConfigInfo;
@interface DragSortController : UIViewController
/** 分类对象 */
@property (strong, nonatomic) SortConfigInfo *sortInfo;
@end
