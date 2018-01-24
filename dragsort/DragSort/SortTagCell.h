//
//  SortTagCell.h
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortConfigInfo.h"

@interface SortTagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (strong, nonatomic) SortTagData *cellData;
/**
 * @description 更新信息
 * @param tagData 类别信息
 * @param selected 是否已选择
 * @param editMode 是否处于编辑模式
 * @param currentSelected 是否处于选中模式
 */
- (void)updateInfo:(SortTagData *)tagData withSelected:(BOOL)selected withEditMode:(BOOL)editMode withCurrentSelectedIndex:(BOOL)currentSelected;
@end
