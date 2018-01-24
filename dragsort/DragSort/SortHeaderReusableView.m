//
//  SortHeaderReusableView.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "SortHeaderReusableView.h"

@interface SortHeaderReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnOperation;

@end

@implementation SortHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnOperation.layer setCornerRadius:12.0f];
    [self.btnOperation.layer setBorderColor:[UIColor redColor].CGColor];
    [self.btnOperation.layer setBorderWidth:1.0f];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)updateInfo:(NSString *)title withDesc:(NSString *)desc withHideBtn:(BOOL)isHide withEditMode:(BOOL)editMode {
    self.lblTitle.text = title;
    self.lblDesc.text = desc;
    self.btnOperation.hidden = isHide;
    [self.btnOperation setSelected:editMode];
}

- (IBAction)btnOperationTouchUpInside:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiBtnOperationSelectedState" object:@(sender.isSelected)];
}

@end
