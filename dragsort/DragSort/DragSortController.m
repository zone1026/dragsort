//
//  DragSortController.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "DragSortController.h"
#import "DragSortDataSource.h"
#import "SortConfigInfo.h"
#import "SortTagCell.h"

typedef NS_ENUM(NSInteger, PanelExpandMode) {
    PanelExpandModeHide,
    PanelExpandModeShow
};

@interface DragSortController () <UIGestureRecognizerDelegate>
/** 数据源 */
@property (strong, nonatomic) IBOutlet DragSortDataSource *sortDataSource;
/** 内容视图 */
@property (weak, nonatomic) IBOutlet UIView *viewPanel;
/** 分类表格 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 分类表格顶部视图 */
@property (weak, nonatomic) IBOutlet UIView *viewTop;
/** 分类表格视图 */
@property (weak, nonatomic) IBOutlet UIView *viewSort;

/** 显示所需要的windown */
@property (strong, nonatomic) UIWindow *showWindow;
/** 面板展开类型 */
@property (assign, nonatomic) PanelExpandMode expandMode;
/** 正在拖拽的sortCell快照 */
@property (strong, nonatomic) UIView *dragingSortSnapshot;
/** 编辑模式 */
@property (assign, nonatomic) BOOL editMode;

@end

@implementation DragSortController
{
    CGFloat lastMoveY;
    CGFloat beganMoveY;
    /** 正在拖拽的indexpath */
    NSIndexPath *dragingIndexPath;
    /** 目标位置indexpath */
    NSIndexPath *targetIndexPath;
    /** 目标开始拖拽时的tag索引*/
    NSInteger beganDragTagIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewTop.layer setCornerRadius:6.0f];
    
    self.showWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
    self.showWindow.rootViewController = self;
    [self.showWindow makeKeyAndVisible];
    
    self.viewPanel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0, self.view.frame.size.height*0.6);
    self.sortDataSource.sortData = self.sortInfo;
    
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotiBtnOperationSelectedState:)
                                                 name:@"NotiBtnOperationSelectedState" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.viewPanel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0, -8.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.viewPanel.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotiBtnOperationSelectedState" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 消息
- (void)handleNotiBtnOperationSelectedState:(NSNotification *)notification {
    if (nil != notification.object)
        self.editMode = [notification.object boolValue];
}

#pragma mark - 事件
/** 关闭事件 */
- (IBAction)btnCloseTouchUpInside:(UIButton *)sender {
    [self closeView];
}
/** 面板拖拽事件 */
- (IBAction)sortPanelPanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    if (self.editMode == YES)
        return;
    
    if (self.collectionView.contentOffset.y > 0) {
        if (self.viewPanel.frame.origin.y > self.topLayoutGuide.length)
            self.expandMode = PanelExpandModeShow;
        lastMoveY = [sender locationInView:self.view].y;
        return;
    }
    
    if (UIGestureRecognizerStateBegan == sender.state) {
        beganMoveY = self.viewPanel.frame.origin.y;
        lastMoveY = [sender locationInView:self.view].y;
    }
    else if (UIGestureRecognizerStateChanged == sender.state) {
        CGFloat maxY = [UIScreen mainScreen].bounds.size.height - 64.0f;
        CGFloat minY = [UIScreen mainScreen].bounds.size.height - self.viewPanel.frame.size.height;
        CGPoint curPoint = [sender locationInView:self.view];
        CGFloat moveY = curPoint.y - lastMoveY;
        if (self.viewPanel.frame.origin.y + moveY > minY && self.viewPanel.frame.origin.y + moveY < maxY)
            self.viewPanel.transform = CGAffineTransformTranslate(self.viewPanel.transform, 0.0f, moveY);
        lastMoveY = curPoint.y;
    }
    else if (UIGestureRecognizerStateEnded == sender.state) {
        CGFloat moveY = self.viewPanel.frame.origin.y - beganMoveY;
        if (moveY > 0) {// 下拉
            if (moveY > self.viewPanel.frame.size.height*0.35) //不到高度的35%，拉起
                self.expandMode = PanelExpandModeHide;
            else
                self.expandMode = PanelExpandModeShow;
        }
        else if (moveY < 0) { //拉起
            if (-moveY > self.viewPanel.frame.size.height*0.35) //拉起
                self.expandMode = PanelExpandModeShow;
            else
                self.expandMode = PanelExpandModeHide;
        }
        lastMoveY = 0.0f;
    }
}

/** 分类视图长按事件 */
- (IBAction)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.collectionView];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:point];
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

/** 是否允许同时支持多个手势，默认是不支持多个手势 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
            shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 私有方法

/** 设置拖拽后的面板展示mode */
- (void)setExpandMode:(PanelExpandMode)expandMode {
    _expandMode = expandMode;
    switch (expandMode) {
        case PanelExpandModeHide:
            [self closeView];
            break;
        default:
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.viewPanel.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {}];
        }
            break;
    }
}

/** 编辑模式 */
- (void)setEditMode:(BOOL)editMode {
    if (_editMode == editMode)
        return;
    _editMode = editMode;
    self.sortDataSource.cellEditMode = editMode;
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [self.collectionView reloadSections:indexSet];
}

/** 关闭视图界面 */
- (void)closeView {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewPanel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [self.showWindow removeFromSuperview];
        [self.showWindow resignKeyWindow];
        self.showWindow = nil;
    }];
}

/** 拖拽开始 找到被拖拽的sortCell */
- (void)dragBegin:(CGPoint)point {
    self.editMode = YES;
    
    dragingIndexPath = [self acquireDragingIndexPathByPoint:point];
    if (nil == dragingIndexPath)
        return;
    beganDragTagIndex = dragingIndexPath.item;
    SortTagCell *selectedCell = (SortTagCell *)[self.collectionView cellForItemAtIndexPath:dragingIndexPath];
    self.dragingSortSnapshot = [self customSnapshoFromView:selectedCell];
    [self.viewSort addSubview:self.dragingSortSnapshot];
    [self.collectionView bringSubviewToFront:self.dragingSortSnapshot];
    self.dragingSortSnapshot.frame = selectedCell.frame;
    self.dragingSortSnapshot.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
    selectedCell.hidden = YES;
}

/** 正在被拖拽 */
- (void)dragChanged:(CGPoint)point {
    if (nil == dragingIndexPath)
        return;
    self.dragingSortSnapshot.center = point;
    targetIndexPath = [self acquireDragingIndexPathByPoint:point];
    if (nil == targetIndexPath)
        return;
    //更新数据源
    [self updateSortData];
    //更新item位置
    [self.collectionView moveItemAtIndexPath:dragingIndexPath toIndexPath:targetIndexPath];
    dragingIndexPath = targetIndexPath;
}

/** 拖拽结束 */
- (void)dragEnd:(CGPoint)point {
    if (nil == dragingIndexPath)
        return;
    
    CGFloat secondSectionMinY = [self.sortDataSource.sortData getPondSortNum] > 0 ?
                [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].frame.origin.y : NSNotFound;
    SortTagCell *endCell = (SortTagCell *)[self.collectionView cellForItemAtIndexPath:dragingIndexPath];
    CGRect endFrame = endCell.frame;
    
    if (secondSectionMinY != NSNotFound && point.y > secondSectionMinY) {//被拖拽至下半部分
        [self.sortDataSource.sortData.selectedSortArr removeObject:endCell.cellData];
        [self.sortDataSource.sortData.pondSortArr insertObject:endCell.cellData atIndex:0];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [self.collectionView moveItemAtIndexPath:dragingIndexPath toIndexPath:toIndexPath];
        [self.collectionView reloadItemsAtIndexPaths:@[toIndexPath]];
        endFrame = [self.collectionView cellForItemAtIndexPath:toIndexPath].frame;
        if (beganDragTagIndex == self.sortDataSource.sortData.selectedIndex)//选中的tag被拖拽到下半部分
            self.sortDataSource.sortData.selectedIndex = 0;
        else if (beganDragTagIndex < self.sortDataSource.sortData.selectedIndex)//选中tag之前的一个tag被拖拽到下半部分
            self.sortDataSource.sortData.selectedIndex --;
    }
    else {
        if (beganDragTagIndex == self.sortDataSource.sortData.selectedIndex)//选中的tag被拖拽
            self.sortDataSource.sortData.selectedIndex = dragingIndexPath.item;
        else {
            //selectedIndex 在beganDragTagIndex和dragingIndexPath之间
            if (self.sortDataSource.sortData.selectedIndex > beganDragTagIndex && self.sortDataSource.sortData.selectedIndex <= dragingIndexPath.item)
                self.sortDataSource.sortData.selectedIndex --;//beganDragTagIndex selectedIndex dragingIndexPath
            else if (self.sortDataSource.sortData.selectedIndex < beganDragTagIndex && self.sortDataSource.sortData.selectedIndex >= dragingIndexPath.item)
                self.sortDataSource.sortData.selectedIndex ++;//dragingIndexPath selectedIndex beganDragTagIndex
        }
    }
    
    self.dragingSortSnapshot.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3f animations:^{
        self.dragingSortSnapshot.frame = endFrame;
    } completion:^(BOOL finished) {
        endCell.hidden = NO;
        [self.dragingSortSnapshot removeFromSuperview];
        self.dragingSortSnapshot = nil;
        dragingIndexPath = targetIndexPath = nil;//清除数据
    }];
}

/** 通过point获取被拖动IndexPath */
- (NSIndexPath *)acquireDragingIndexPathByPoint:(CGPoint)point {
    NSIndexPath *dragIndexPath = nil;
    if ([self.collectionView numberOfItemsInSection:0] == 1)
            return dragIndexPath;
    dragIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    //待选池中的标签不可以排序
    if (dragIndexPath.section > 0)
        return nil;
    SortTagData *cellData = ((SortTagCell *)[self.collectionView cellForItemAtIndexPath:dragIndexPath]).cellData;
    if (cellData.fixed == YES)
        return nil;
    return dragIndexPath;
}

/** 通过一个sortCell生成一个快照 */
- (UIView *)customSnapshoFromView:(SortTagCell *)cell {
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

/** 拖拽排序后需要重新排序数据源 */
- (void)updateSortData {
    if (nil == self.sortDataSource.sortData)
        return;
    
    SortTagData *cellData = [self.sortDataSource.sortData.selectedSortArr objectAtIndex:dragingIndexPath.item];
    [self.sortDataSource.sortData.selectedSortArr removeObject:cellData];
    [self.sortDataSource.sortData.selectedSortArr insertObject:cellData atIndex:targetIndexPath.item];
}

@end
