//
//  MyCommentViewController.m
//  MakeFriend
//
//  Created by dianji on 13-9-2.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "MyCommentViewController.h"
#import "UIButton+WebCache.h"
#import "CommentInfoCell.h"
#import "ASIFormDataRequest.h"
@interface MyCommentViewController ()

@end

@implementation MyCommentViewController
@synthesize conmmtArray,wishInfo,constellatory;
-(void)dealloc
{
    [conmmtArray release];
    [wishInfo release];
    constellatory=nil;

    [super dealloc];
}
//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)myWishBackButtonClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)creatMyCommentViewNavGationView
{
    
    //自定义导航条
    myCommentNav=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    myCommentNav.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:myCommentNav];
    [myCommentNav release];
    //加上x和钩和标题
    myCommentTitle=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 90, 35)];
    myCommentTitle.text=@"心愿评论";
    myCommentTitle.font=[UIFont fontWithName:@"Arial-BoldMT" size:18];
    myCommentTitle.textColor=[UIColor whiteColor];
    myCommentTitle.backgroundColor=[UIColor clearColor];
    [myCommentNav addSubview:myCommentTitle];
    [myCommentTitle release];
    //加上返回按钮和钩
    myCommentBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [myCommentBackButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [myCommentBackButton addTarget:self action:@selector(myWishBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    myCommentBackButton.frame=CGRectMake(10, 10, 30, 27);
    [myCommentNav addSubview:myCommentBackButton];
    
    
}
-(void)creatConmmentTable
{
    _myCommentTable=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain ];
    _myCommentTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _myCommentTable.separatorColor=[UIColor blackColor];
    _myCommentTable.delegate=self;
    _myCommentTable.dataSource=self;
    UIView* groundView = [[[UIView alloc]initWithFrame:_myCommentTable.bounds] autorelease];
    groundView.backgroundColor=[UIColor clearColor];
    _myCommentTable.backgroundView=groundView;
    
    _myCommentTable.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentBakGroung.png"]];
    _myCommentTable.frame=CGRectMake(15, self.view.bounds.size.height-160-[Tools isIphone5], 290, 160);
    [self.view addSubview:_myCommentTable];
    [_myCommentTable release];
    
}
-(UIImage*)chooseConstellationImage:(NSString*)constellation
{
    if ([constellation isEqualToString:@"魔羯"]) {
        return [UIImage imageNamed:@"mojie.png"];
    }
    if ([constellation isEqualToString:@"水瓶"]) {
        return [UIImage imageNamed:@"shuipin.png"];
    }
    if ([constellation isEqualToString:@"双鱼"]) {
        return [UIImage imageNamed:@"shuangyu.png"];
    }
    if ([constellation isEqualToString:@"白羊"]) {
        return [UIImage imageNamed:@"baiyang.png"];
    }
    if ([constellation isEqualToString:@"金牛"]) {
        return [UIImage imageNamed:@"jinniu.png"];
    }
    if ([constellation isEqualToString:@"双子"]) {
        return [UIImage imageNamed:@"shuangzi.png"];
    }
    if ([constellation isEqualToString:@"巨蟹"]) {
        return [UIImage imageNamed:@"juxie.png"];
    }
    if ([constellation isEqualToString:@"狮子"]) {
        return [UIImage imageNamed:@"shizi.png"];
    }
    if ([constellation isEqualToString:@"处女"]) {
        return [UIImage imageNamed:@"chunv.png"];
    }
    if ([constellation isEqualToString:@"天秤"]) {
        return [UIImage imageNamed:@"tianping.png"];
    }
    if ([constellation isEqualToString:@"天蝎"]) {
        return [UIImage imageNamed:@"tianxie.png"];
    }
    if ([constellation isEqualToString:@"射手"]) {
        return [UIImage imageNamed:@"sheshou.png"];
    }
    return nil;
}
-(UIImage*)chooseSexImage:(NSString*)sexStr
{
    switch ([sexStr intValue]) {
        case 0://男性
        {
            return [UIImage imageNamed:@"man.png"];
            break;
        }
        case 1://女性
        {
            return [UIImage imageNamed:@"woman.png"];
            break;
        }
        default:
            break;
    }
    return nil;
    
}
-(void)commentButtonClicked:(UIButton*)sender
{
    [commenttextView becomeFirstResponder];
    conmmetBackView.frame=CGRectMake(0, self.view.bounds.size.height-80-256,320, 40);
    
    
}
-(void)creatLargeImageView
{
    //大背景
    UIView*largeView=[[UIView alloc]initWithFrame:CGRectMake(6, 44+10, 308, 249)];
    largeView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"largeView.png"]];
    [self.view addSubview:largeView];
    [largeView release];
    //上方的基本资料布局
    UIButton*littleImage=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    littleImage.frame=CGRectMake(20, -5, 40, 40);
    [littleImage setImageWithURL:[NSURL URLWithString:wishInfo.useraLitleImageURL]];
    [littleImage addTarget:self action:@selector(littleImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [largeView addSubview:littleImage];
    //昵称
    UILabel* nickName=[[UILabel alloc]initWithFrame:CGRectMake(63, 0, 40, 20)];
    nickName.text=wishInfo.userName;
    nickName.textColor=[UIColor whiteColor];
    nickName.backgroundColor=[UIColor clearColor];
    nickName.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
    [largeView addSubview:nickName];
    [nickName release];
    //星座
    UIImageView*constellation=[[UIImageView alloc]initWithFrame:CGRectMake(67+40, 5, 10, 10)];
    constellation.image=[self chooseConstellationImage:self.constellatory];
    [largeView addSubview:constellation];
    [constellation release];
    //性别
    UIImageView *sexImage=[[UIImageView alloc]initWithFrame:CGRectMake(63, 22, 10, 12)];
    sexImage.image=[self chooseSexImage:wishInfo.userSex];
    [largeView addSubview:sexImage];
    [sexImage release];
    
    
    //放大图的button
    UIButton*commentImage=[UIButton buttonWithType:UIButtonTypeCustom];
    commentImage.frame=CGRectMake(1, 40, largeView.bounds.size.width-2, 249-40-30);
    [commentImage setImageWithURL:[NSURL URLWithString:wishInfo.useraLargeImageURL]];
    [largeView addSubview:commentImage];
    //下方的一句愿望和评论按钮
    UILabel* commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(23, largeView.bounds.size.height-28, 200, 25)];
    commentLabel.text=wishInfo.userWish;
    commentLabel.textColor=[UIColor whiteColor];
    commentLabel.backgroundColor=[UIColor clearColor];
    commentLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
    [largeView addSubview:commentLabel];
    [commentLabel release];
    
    UIButton*commetBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [commetBut setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [commetBut addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    commetBut.frame=CGRectMake(280, largeView.bounds.size.height-25, 20, 20);
    [largeView addSubview:commetBut];
    
}

-(NSString *)getAstroWithMonth:(int)m day:(int)d
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
    
}
//处理生日转化为星座
-(void)handleBirthday
{
    NSArray *birthArray=[[NSArray alloc]init];
    birthArray=[wishInfo.userBirth componentsSeparatedByString:@"-"];
    int month=[[birthArray objectAtIndex:1]intValue];
    int day=[[birthArray objectAtIndex:2]intValue];
    NSLog(@"month:%d  day:%d",month,day);
    self.constellatory=[self getAstroWithMonth:month day:day];
    NSLog(@"%@",self.constellatory);
}
-(void)cancelButton
{
    [commenttextView resignFirstResponder];
    commenttextView.userInteractionEnabled=YES;
    conmmetBackView.frame=CGRectMake(0, self.view.bounds.size.height-40,320, 40);
    
}
-(void)chooseDone
{
    [commenttextView resignFirstResponder];
    commenttextView.userInteractionEnabled=YES;
    conmmetBackView.frame=CGRectMake(0, self.view.bounds.size.height-40,320, 40);
}

-(void)sendComment:(UIButton*)sender
{
    //使用本地注册手机号码作为发送评论的参数，还有一个参数是评论谁
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString*userName=[defaults objectForKey:@"PHONE_NUMBER"];
    
    NSString*url=[[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?m_userinfor=%@&N_user=%@",wishInfo.userRegestName,userName]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send  commet  url:%@",url);
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL: [NSURL URLWithString:url]];
    
    //启动异步下载
    [request setPostValue:[NSString stringWithFormat:@"%@",wishInfo.userRegestName] forKey:@"m_user"];
    [request setPostValue:[NSString stringWithFormat:@"%@",userName] forKey:@"n_user"];
    [request setPostValue:[NSString stringWithFormat:@"%@",wishInfo.userID] forKey:@"w_id"];
    [request setPostValue:[NSString stringWithFormat:@"%@",commenttextView.text] forKey:@"comment_content"];
    
    [request setDelegate:self];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"已经提交到后台进行审核，请耐心等候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        [alter release];
        conmmetBackView.frame=CGRectMake(0, self.view.bounds.size.height,320, 40);
        commenttextView.text=@"说点什么...";
        
    }];
    [request setFailedBlock:^{
        NSLog(@"asi error: %@",request.error.debugDescription);
        [Tools showPrompt:@"上传超时，请点击上传按钮再试一次，谢谢你的配合" inView:self.view delay:0.5];
        
    }];
    
    [request buildRequestHeaders];
    [request startAsynchronous];
    NSLog(@"responseString = %@", request.responseString);
    
    
    
    
}
-(void)creatConmmentTextView
{
    //创建背景view
    conmmetBackView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 40)];
    conmmetBackView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentTextBack.png"]];
    [self.view addSubview:conmmetBackView];
    [conmmetBackView release];
    
    commenttextView=[[UITextView alloc]initWithFrame:CGRectMake(4, 4, 250, 32)];
    commenttextView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    commenttextView.font=[UIFont systemFontOfSize:14];
    commenttextView.textColor=[UIColor grayColor];
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
    
    commenttextView.inputAccessoryView=keybordBar;
    [keybordBar release];
    commenttextView.text=@"说点什么...";
    commenttextView.delegate=self;
    [conmmetBackView addSubview:commenttextView];
    [commenttextView release];
    
    //添加发送按钮
    sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame=CGRectMake(260, 5, 50, 30);
    [sendButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"commentSend.png"] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [conmmetBackView addSubview:sendButton];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    if ([Tools isIphone5]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView5.png"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView.png"]];
    }
 //   self.conmmtArray = [[NSMutableArray alloc] init];
    //处理生日转化为星座
    [self handleBirthday];
	[self creatMyCommentViewNavGationView];
    [self creatConmmentTable];
    [self creatLargeImageView];
    //创建评论textview和自定义键盘
    [self creatConmmentTextView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark --tableViewDelegate
//tableview的必须实现的方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [conmmtArray count];
    
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=nil;
    NSLog(@"%d",[conmmtArray count]);
    if ([conmmtArray count]<=indexPath.row) {
        return cell;
    }
    ConmentInfo *info = [conmmtArray objectAtIndex:indexPath.row];
    NSLog(@"info.XXX = %@",info.commentStr);
    if (cell == nil) {
        cell = [[[CommentInfoCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:nil message:info delegate:self] autorelease];
        if (indexPath.row==[conmmtArray count]-1) {
            //在table下面加一个无更多评论
            NSLog(@"......%d.....",[conmmtArray count]);
            UILabel *notMore=[[UILabel alloc]initWithFrame:CGRectMake(110,50, 70, 20)];
            notMore.textAlignment=NSTextAlignmentCenter;
            notMore.textColor=[UIColor grayColor];
            notMore.backgroundColor=[UIColor clearColor];
            notMore.text=@"无更多评论";
            notMore.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
            [cell addSubview:notMore];
            [notMore release];
        }
    }
    
    
    return cell;
    
}
#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    commenttextView.text=@"";
    if (CGRectGetMaxY(conmmetBackView.frame) > 450){//上移
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = conmmetBackView.frame;
            rect.origin.y =self.view.bounds.size.height-256-40-40;
            conmmetBackView.frame = rect;
            
        }
                         completion:^(BOOL finished) {
                         }];
        
        
    }
}

@end
