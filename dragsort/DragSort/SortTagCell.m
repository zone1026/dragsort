//
//  SortTagCell.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "SortTagCell.h"

@interface SortTagCell ()
@property (weak, nonatomic) IBOutlet UIView *viewTag;
@property (weak, nonatomic) IBOutlet UIImageView *imgDel;
@end

@implementation SortTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)updateInfo:(SortTagData *)tagData withSelected:(BOOL)selected withEditMode:(BOOL)editMode
                                            withCurrentSelectedIndex:(BOOL)currentSelected {
    self.cellData = tagData;
    self.viewTag.layer.cornerRadius = 4.0f;
    self.viewTag.layer.shadowColor = (selected == NO) ? [UIColor darkGrayColor].CGColor : [UIColor clearColor].CGColor;
    self.viewTag.layer.shadowOpacity = (selected == NO) ? 0.5f : 0.0f;
    self.viewTag.layer.shadowRadius = (selected == NO) ? 2.0f : 0.0f;
    self.viewTag.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.viewTag.backgroundColor = (selected == NO) ? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];
    
    self.lblTag.text = (tagData != nil) ? (selected == NO ? [NSString stringWithFormat:@"+%@", tagData.desc] : tagData.desc) : @"未知";
    self.imgDel.hidden = selected == YES ? (tagData.fixed == YES ? YES : !editMode) : YES;
    
    self.lblTag.textColor = [UIColor blackColor];
    if (selected == YES) {
        if (currentSelected == YES)
            self.lblTag.textColor = [UIColor redColor];
        else {
            if (tagData != nil && tagData.fixed == YES)
                self.lblTag.textColor = [UIColor lightGrayColor];
        }
    }
}

@end
