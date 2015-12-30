//
//  ListView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "ListView.h"

@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)updateListView
{
    [self setUserInteractionEnabled:YES];
    [self.mPeripheralListView reloadData];
}
#pragma mark - TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[[[EADSessionController sharedController] getBleSocketClient] mPeripheralArray] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
   
    //cell.accessoryType =UITableViewCellAccessoryDetailButton;
   CBPeripheral * peripheral = [[[[EADSessionController sharedController] getBleSocketClient] mPeripheralArray] objectAtIndex:indexPath.row];
    cell.textLabel.text = peripheral.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
     CBPeripheral * peripheral = [[[[EADSessionController sharedController] getBleSocketClient] mPeripheralArray] objectAtIndex:indexPath.row];
    [[[EADSessionController sharedController] getBleSocketClient] ConnectPeripheralMsg:peripheral];
    [self setUserInteractionEnabled:NO];
    [self setHidden:YES];
    [self performSelector:@selector(BeginAll) withObject:nil afterDelay:3.0f];
}
-(void)BeginAll
{
    [self.delegate showView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
