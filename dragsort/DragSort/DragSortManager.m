//
//  DragSortManager.m
//  exercise
//
//  Created by 黄亚州 on 2018/1/10.
//  Copyright © 2018年 hyz. All rights reserved.
//

#import "DragSortManager.h"
#import <UIKit/UIKit.h>
#import "DragSortController.h"
#import "SortConfigInfo.h"
#import "ShelfSortData.h"

@implementation DragSortManager

+ (instancetype)sharedManager {
    static DragSortManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)openDragSortView:(NSString *)sortIdentify withSortDataSource:(NSArray *)sortList {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DragSort" bundle:nil];
    DragSortController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DragSortController"];
    vc.sortInfo = [self getSortDataByIdentify:sortIdentify];
    vc.view.frame = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (SortConfigInfo *)getSortDataByIdentify:(NSString *)identify {
    SortConfigInfo *data;
    if ([identify isEqualToString:@"shelf"])
        data = [[ShelfSortData alloc] init];
    
    if (data == nil)
        data = [[SortConfigInfo alloc] init];
    
    return data;
}

@end
