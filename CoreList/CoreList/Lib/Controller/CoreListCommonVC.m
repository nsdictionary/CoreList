//
//  CoreListController.m
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreListCommonVC.h"
#import "CoreModel+Compare.h"
#import "CoreListCommonVC+ScrollView.h"
#import "corelistEmptyView.h"


@interface CoreListCommonVC ()




@end


@implementation CoreListCommonVC


-(NSUInteger)modelPageSize{
    
    if(_modelPageSize == 0){
        
        _modelPageSize = [[self listVC_Model_Class] CoreModel_PageSize];
    }
    
    return _modelPageSize;
}

-(void)setDataList:(NSArray *)dataList{
    
    _dataList=dataList;
    
    if(!self.needCompareData) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [CoreModel compareArr1:_dataList arr2:dataList resBlock:^(BOOL res) {
            
            if(!res && self.DataListChangedAction!=nil) self.DataListChangedAction();
        }];
    });
}



-(void)setShyNavBarOff:(BOOL)shyNavBarOff{

    _shyNavBarOff = shyNavBarOff;

    if(shyNavBarOff){
    
        [self navBarScroll_Disable];
    }
}

-(UIView *)back2TopView {

    
    if(_back2TopView == nil){
        
        _back2TopView = [[UIView alloc] init];
        
        CGFloat wh = 30;
        CGRect frame = CGRectMake(0, 0, wh, wh);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn setBackgroundImage:[UIImage imageNamed:@"CoreList.bundle/back_top"] forState:UIControlStateNormal];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:frame];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        [_back2TopView addSubview:toolBar];
        [_back2TopView addSubview:btn];
        
        //隐藏
        _back2TopView.alpha = 0;
        
        [btn addTarget:self action:@selector(back2Top) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_back2TopView];
        CGFloat marginBottom = 20;
        if(!self.hidesBottomBarWhenPushed && self.tabBarController != nil && !self.tabBarController.tabBar.hidden) {marginBottom += self.tabBarController.tabBar.bounds.size.height;}
        
        
        _back2TopView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{@"back2TopView": _back2TopView};
        
        NSArray *v_hor = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[back2TopView(==%@)]-20-|", @(wh)] options:0 metrics:nil views:views];
        NSArray *v_ver = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[back2TopView(==%@)]-%@-|", @(wh),@(marginBottom)] options:0 metrics:nil views:views];
        [self.view addConstraints:v_hor];[self.view addConstraints:v_ver];
        
        _back2TopView.layer.cornerRadius = wh/2;
        _back2TopView.layer.masksToBounds = YES;
        _back2TopView.clipsToBounds = YES;
    }
    
    return _back2TopView;
}


-(UIView *)emptyView{

    return [CoreListEmptyView emptyViewWithImageName:@"nil" desc:@"Defalt EmptyView" constant:0];
}

-(UIView *)errorView{
    
    return [CoreListEmptyView emptyViewWithImageName:@"nil" desc:@"Defalt ErrorView" constant:0];
}


@end
