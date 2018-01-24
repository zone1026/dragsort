//
//  SortHeaderReusableView.h
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortHeaderReusableView : UICollectionReusableView
/**
 * @description 更新信息
 * @param title 标题
 * @param desc 辅助信息
 * @param isHide 是否隐藏操作按钮
 * @param editMode 是否处于编辑模式下
 */
- (void)updateInfo:(NSString *)title withDesc:(NSString *)desc withHideBtn:(BOOL)isHide withEditMode:(BOOL)editMode;
@end
