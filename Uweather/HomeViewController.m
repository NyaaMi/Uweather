//
//  HomeViewController.m
//  Uweather
//
//  Created by Nyaa_Mi on 2018/3/12.
//  Copyright © 2018年 Nyaa_Mi. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+LBBlurredImage.h"

@interface HomeViewController ()

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIImageView *blurredImageView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat screenHeight;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取屏幕高度，设置以分页方式显示所有天气数据
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //创建一个静态图像，添加到视图
    UIImage *background = [UIImage imageNamed:@"bg"];
    self.backgroundImageView = [[UIImageView alloc]initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    //使用LBBlurredImage框架创建一个模糊背景，设置alpha值为0
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill ;
    self.blurredImageView.alpha = 0 ;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    //设置代理
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2 ];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    //将table设置和屏幕同样大小
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    //创建inset变量
    CGFloat inset = 20;
    
    //为视图初始化高度变量
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    //使用inset变量和常量，为label和view创建框架
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - 2*inset, hiloHeight);
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - temperatureHeight - hiloHeight, headerFrame.size.width - 2*inset, temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    CGRect conditionsFrame = iconFrame;
    
    //复制图标框并进行调整，移动到该图标右侧，使得具有扩展空间。
    conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
    conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
    
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    //设置当前的view为顶部标题
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];
    
    //底部内容
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
    
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:conditionsLabel];
    
    //左下角内容
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:iconView];
    
    // Do any additional setup after loading the view.
}


//设置状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleLightContent ;
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: Determine cell height based on screen
    return 44;
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
