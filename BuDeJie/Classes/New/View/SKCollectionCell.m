//
//  SKCollectionCell.m
//  BuDeJie
//
//  Created by hongchen li on 2022/3/15.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKCollectionCell.h"
@interface SKCollectionCell()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SKCollectionCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.dataSource =self;
    self.tableView.backgroundColor = SKRandomColor;
}

//避免循环利用，需要重写set方法，负值给当前的model，刷新表格
- (void)setModel:(NSString *)model{
    //需要注意在这需要取消刷新控件网络请求，或者延迟执行的操作，需要结束，避免出现数据错乱
    _model = [model copy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建cell
    static NSString *const cid = @"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd",self.model,indexPath.row];
    return cell;
}
@end
