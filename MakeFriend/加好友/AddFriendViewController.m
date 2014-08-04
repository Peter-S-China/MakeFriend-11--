//
//  AddFriendViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end


@implementation AddFriendViewController
@synthesize month,day,year;

- (void)dealloc
{
   
    [day release];
    [year release];
    [month release];
    [super dealloc];
}


-(void)chooseMyBirthday
{
    //初始化生日设定的view，方便隐藏
    chooseMyBirthdayView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    chooseMyBirthdayView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:chooseMyBirthdayView];
    [chooseMyBirthdayView release];
    //“生日设定”加一条线
    UILabel*birthLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 20, 90, 35)];
    birthLabel.text=@"生日设定";
    birthLabel.font=[UIFont systemFontOfSize:16];
    birthLabel.textColor=[UIColor colorWithRed:0.2 green:0.45 blue:0.9 alpha:1];
    birthLabel.backgroundColor=[UIColor clearColor];
    [chooseMyBirthdayView addSubview:birthLabel];
    [birthLabel release];
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, 56, self.view.bounds.size.width, 1)];
    line.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    [chooseMyBirthdayView addSubview:line];
    [line release];
//加上三个view
    for (int i=0; i<3; i++) {
        UIView*backview=[[UIView alloc]initWithFrame:CGRectMake(70+i*80, 85, 30, 177)];
        backview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"chooseBirthdayBack.png"]];
        [chooseMyBirthdayView addSubview:backview];
        [backview release];
    }
    
}
-(void)rightButtonClicked:(UIButton*)sender
{
    if (navView||chooseMyBirthdayView) {
   
    [navView removeFromSuperview];
    [chooseMyBirthdayView removeFromSuperview];
    }
    else
    {
    
    }
    [self creatMyWishView];
    /*
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"1"],
                         [UIImage imageNamed:@"2"],
                         [UIImage imageNamed:@"3"],
                         [UIImage imageNamed:@"4"],nil];
    gifImageView.animationImages = gifArray; //动画图片数组
    gifImageView.animationDuration = 5; //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 1;  //动画重复次数
    [gifImageView startAnimating];
    [self.view addSubview:gifImageView];
    [gifImageView release];
[self performSelector:@selector(doOtherAction) withObject:nil afterDelay:5];
     */
}
-(void)wrongButtonClicked:(UIButton*)sender
{
   
    
}


-(void)previewButtonClicked:(UIButton*)sender
{
    NSLog(@"%@%@%@",self.month,self.day,self.year);
    PreVIewViewController*nacc=[[PreVIewViewController alloc]init];
    if (selctedimage) {
        nacc.selctedImage=selctedimage;
    }
    else{
        [Tools showPrompt:@"照片不能为空" inView:self.view delay:0.4];
    }
    nacc.wishString=writeWishField.text;
    nacc.preAddress=addressLabel.text;
    nacc.preMonth=self.month;
    nacc.preDay=self.day;
    nacc.preYear=self.year;
    [self.navigationController pushViewController:nacc animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [nacc release];

}
-(void)wrongButton1Clicked:(UIButton*)sender
{
    [self creatChooseBirthdayView];
}
-(void)creatMyWishNavGationView
{
    
    //自定义导航条
    navView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView1];
    [navView1 release];
    //加上x和钩和标题
    navTitle1=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 90, 35)];
    navTitle1.text=@"我的愿望";
    navTitle1.font=[UIFont fontWithName:@"Arial-BoldMT" size:18];
    navTitle1.textColor=[UIColor whiteColor];
    navTitle1.backgroundColor=[UIColor clearColor];
    [navView1 addSubview:navTitle1];
    [navTitle1 release];
    //加上x和钩
    previewButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [previewButton setImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    [previewButton addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    previewButton.frame=CGRectMake(self.view.bounds.size.width-30, 13, 20, 16);
    [navView1 addSubview:previewButton];
    
    wrongButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    [wrongButton1 setImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
    [wrongButton1 addTarget:self action:@selector(wrongButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    wrongButton1.frame=CGRectMake(10, 10, 30, 27);
    [navView1 addSubview:wrongButton1];
   
    
}
-(void)takePhoto:(UIButton*)sender
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else//选择本地相册
	{
        camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        camera.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		NSLog(@"Camera not exist");
	}
    
    [self presentViewController:camera animated:YES completion:^(void){
        NSLog(@" ————开始拍照———— ");
        
    }];
	[camera release];
    
}
-(void)weiboClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 101:
        {
            
            break;
        }
        case 102:
        {
            
            break;
        }
        case 103:
        {
            
            break;
        }
        default:
            break;
    }


}
-(void)cancelButton
{
    [writeWishField resignFirstResponder];
    writeWishField.userInteractionEnabled=YES;
       
}
-(void)chooseDone
{
    [writeWishField resignFirstResponder];
    writeWishField.userInteractionEnabled=YES;
   
}

-(void)showPicker:(UIButton*)sender
{
    count++;
    NSLog(@"count...:%d",count);
    if (!addressTable) {
        //创建tableview
        addressTable=[[UITableView alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height-45, 80,40) style:UITableViewStylePlain];
        addressTable.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [addressTable setBackgroundColor:[UIColor grayColor]];
        addressTable.delegate=self;
        addressTable.dataSource=self;
        addressTable.hidden=NO;
        [self.view addSubview:addressTable];
        [addressTable release];
  
    }else
    {
   
      if (count%2) {
       addressTable.hidden=NO;         
    
    }
    else
    {
   addressTable.hidden=YES;
    
    }
    
   
    }
   
    }
-(void)creatMyWishView
{
    [self creatMyWishNavGationView];
    
    wishView=[[UIView alloc]initWithFrame:CGRectMake(5, 135, 310, self.view.bounds.size.height-170)];
    wishView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"myWishView.png"]];
    wishView.userInteractionEnabled=YES;
    [self.view addSubview:wishView];
    [wishView release];
  //创建照片选择按钮
    UIImageView*photoBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, -80, 108, 115)];
    photoBackImage.userInteractionEnabled=YES;
    photoBackImage.image=[UIImage imageNamed:@"takePhoto.png"];
    [wishView addSubview:photoBackImage];
    [photoBackImage release];
    
    takePhoto=[UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame=CGRectMake(4, 4, 100, 100);
    [takePhoto setImage:nil forState:UIControlStateNormal];
    [takePhoto addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoBackImage addSubview:takePhoto];
   //同步到微博之类的三个社交按钮、
    for (int i=0; i<3; i++) {
        UIButton*weibo=[UIButton buttonWithType:UIButtonTypeCustom];
        [weibo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"weibo%i",i+1]] forState:UIControlStateNormal];
        weibo.tag=101+i;
        [weibo addTarget:self action:@selector(weiboClicked:) forControlEvents:UIControlEventTouchUpInside];
        weibo.frame=CGRectMake(227+i*25, 10, 21, 21);
        [wishView addSubview:weibo];
    }
  //初始化写愿望的textfield
    writeWishField=[[UITextView alloc]initWithFrame:CGRectMake(20, 50, 270, 130)];
    writeWishField.backgroundColor=[UIColor clearColor];
    writeWishField.returnKeyType= UIReturnKeyDefault;//返回键的类型
    writeWishField.font=[UIFont systemFontOfSize:18];
    writeWishField.textColor=[UIColor grayColor];
    //自定义键盘
    
    UIToolbar *keybordBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, 320, 44)];
    keybordBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButton)];
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(chooseDone)];
    keybordBar.items = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,hiddenButtonItem, nil];
    [spaceButtonItem release];
    [cancelButtonItem release];
    [hiddenButtonItem release];
    
    writeWishField.inputAccessoryView=keybordBar;
    [keybordBar release];

    writeWishField.text=@"说出你的心语心愿...";
    writeWishField.delegate=self;
    [wishView addSubview:writeWishField];
    [writeWishField release];
    
    //初始化地址，一个imageview。一个label。一个button可下拉出现地址选择的选择器
    UIImageView*addressimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, wishView.bounds.size.height-30, 87, 20)];
    addressimage.userInteractionEnabled=YES;
    addressimage.image=[UIImage imageNamed:@"addressimage.png"];
    [wishView addSubview:addressimage];
    [addressimage release];
    
    UIImageView*tubiao=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 8, 10)];
    tubiao.image=[UIImage imageNamed:@"tubiao.png"];
    [addressimage addSubview:tubiao];
    [tubiao release];
    
    addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 20)];
    addressLabel.text=@"广安门内";
    addressLabel.backgroundColor=[UIColor clearColor];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    addressLabel.font=[UIFont systemFontOfSize:10];
    [addressimage addSubview:addressLabel];
    [addressLabel release];
    
    UIButton*addressPicker=[UIButton buttonWithType:UIButtonTypeCustom];
    addressPicker.frame=CGRectMake(62, 0, 25, 20);
    [addressPicker setImage:nil forState:UIControlStateNormal];
    [addressPicker addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [addressimage addSubview:addressPicker];
    
    
    
}
-(void)creatNavGationView
{

    //自定义导航条
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    //加上x和钩和标题
    navTitle=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 90, 35)];
    navTitle.text=@"生日信息";
    navTitle.font=[UIFont fontWithName:@"Arial-BoldMT" size:18];
    navTitle.textColor=[UIColor whiteColor];
    navTitle.backgroundColor=[UIColor clearColor];
    [navView addSubview:navTitle];
    [navTitle release];
    //加上x和钩
    rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(self.view.bounds.size.width-30, 13, 20, 16);
    [navView addSubview:rightButton];
    wrongButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [wrongButton setImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
    [wrongButton addTarget:self action:@selector(wrongButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    wrongButton.frame=CGRectMake(10, 10, 30, 27);
    [navView addSubview:wrongButton];
 //设定生日出现动画，动画结束后填写愿望
    
    [self chooseMyBirthday];
}
-(void)creatChooseBirthdayView
{
    if (wishView||navView1) {
    [wishView removeFromSuperview];
    [navView1 removeFromSuperview];
    }
    else
    {
    
    }
    count=0;
    self.year=@"Feb";
    self.month=@"02";
    self.day=@"1971";
    addressArray=[[NSMutableArray alloc]initWithObjects:@"东城区",@"西城区",@"宣武区",@"崇文区",@"朝阳区",@"海淀区",@"丰台区",@"石景山区",@"通州区",@"大兴区",@"房山区",@"门头沟区",@"昌平区",@"延庆县",@"怀柔区",@"顺义区",@"平谷区",@"密云县", nil];
    
    
    [self.navigationController setNavigationBarHidden:YES];
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
    [self creatNavGationView];
    
    MWDatePicker *datePicker = [[MWDatePicker alloc] initWithFrame:CGRectMake(40, 90, 240, 167)];
    [datePicker setDelegate:self];
    [datePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [datePicker setFontColor:[UIColor whiteColor]];
    [datePicker update];
    
    [datePicker setDate:nil animated:YES];
    
    [chooseMyBirthdayView addSubview:datePicker];
    dayArray = [[NSArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil];
    
    yearArray = [[NSArray alloc]initWithObjects:@"1970",@"1971",@"1972",@"1973",@"1974",@"1975",@"1976",@"1977",@"1978",@"1979",@"1980",@"1981",@"1982",@"1983",@"1984",@"1985",@"1986",@"1987",@"1988",@"1989",@"1990",@"1991",@"1992",@"1993",@"1994",@"1995",@"1996",@"1997",@"1998",@"1999",@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",nil];
    
    monthArray=[[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May ",@"Jun",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
[[MyTableBarController sharedTabBarController]hideTabbar:NO];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatChooseBirthdayView];
}
#pragma mark - MWPickerDelegate

- (UIColor *) backgroundColorForDatePicker:(MWDatePicker *)picker
{
    return [UIColor clearColor];
}


- (UIColor *) datePicker:(MWDatePicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [UIColor clearColor];
        case 1:
            return [UIColor clearColor];
        case 2:
            return [UIColor clearColor];
        default:
            return 0; // never
    }
}


- (UIColor *) viewColorForDatePickerSelector:(MWDatePicker *)picker
{
    return [UIColor clearColor];
}

-(void)datePicker:(MWDatePicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
           self.month=[[monthArray objectAtIndex:row]copy];
            break;
        }
        case 1:
        {
            self.day=[[dayArray objectAtIndex:row]copy];
            break;
        }
        case 2:
        {
            self.year=[[yearArray objectAtIndex:row]copy];
            break;
        }

        default:
            break;
    }
    NSLog(@"month:%@ day:%@ year:%@",self.month,self.day,self.year);
    
}

-(void)saveImage:(UIImage *) image
{
    [takePhoto setImage:image forState:UIControlStateNormal];
}
#pragma mark ImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){//如果是从照片中选择的
        selctedimage = [info objectForKey:UIImagePickerControllerEditedImage];
        //图片存入相册
        //      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self saveImage:selctedimage];
    }
    else
    {
       selctedimage= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        [self saveImage:selctedimage];
        
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
        
        NSLog(@"  ————拍照完成————  ");
    }];
}
#pragma mark-textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  if([writeWishField.text isEqualToString:@"说出你的心语心愿..."])
{
  writeWishField.text=@"";
}
else
{
}

    return YES;
}
#pragma mark - TableView Delegate
//三个必需实现的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [addressArray count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text =[addressArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    return cell;
}
- (void)tableView:(UITableView *)tableView

didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
   
    addressLabel.text=[addressArray objectAtIndex:indexPath.row];
}

@end
