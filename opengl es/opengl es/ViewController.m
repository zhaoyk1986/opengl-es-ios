//
//  ViewController.m
//  opengl es
//
//  Created by lotus on 2021/1/21.
//

#import "ViewController.h"
#import "OpenglWindowController.h"

//这两个协议必须服从
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"构建一个窗口", @"绘制一个三角形", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];

    //设置delegate和DataSouce
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}

//每行显示什么东西
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 重用标识
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *ID = @"cell";
    
    //从tableView的一个队列里获取一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //判断队列里面是否有这个cell 没有自己创建，有直接使用
    if (cell == nil) {
        //没有,创建一个
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    //使用cell
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

//配置每个section(段）有多少row（行） cell
//默认只有一个section
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//配置多个section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//1段
}


//设置高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//某个cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController * shareVC = nil;
    
    switch (indexPath.row) {
        case 1:
            shareVC = [[OpenglWindowController alloc]init];
            break;
            
            
        default:
            shareVC = [[OpenglWindowController alloc]init];
            break;
    }
      
    shareVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:shareVC animated:YES completion:nil];
    
}
 

@end
