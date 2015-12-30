//
//  ListView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EADSessionController.h"
@protocol ListDelegate <NSObject>
-(void)showView;
@end
@interface ListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mPeripheralListView;
@property(nonatomic,strong)id delegate;
-(void)updateListView;
@end
