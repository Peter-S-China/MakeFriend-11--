//
//  AddEventViewController.m
//  ONE
//
//  Created by dianji on 13-5-3.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AddEventViewController.h"
#import "ContentViewController.h"
#import "preViewViewController.h"
@interface AddEventViewController ()

@end

@implementation AddEventViewController

-(void)dealloc
{
    [super dealloc];

}

-(void)backButtonClicked:(UIButton*)sender
{

    [self.navigationController popViewControllerAnimated:YES];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)updateImage:(UIButton*)sender
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
    
    }
-(void)cancelButtonClicked:(UIButton*)sender
{
//    
    telContent.text=nil;
    timeContent.text=nil;
    titleContent.text=nil;
   abstractContent.text=nil;
   addressContent.text=nil;
}

-(void)previewButtonClicked:(UIButton*)sender
{
    if ([titleContent.text length]<1||[timeContent.text length]<1||
        [abstractContent.text length]<1||[addressContent.text length]<1
        ||[telContent.text length]<1||pickImage.image==nil) {
        [Tools showPrompt:@"请把信息填写完整" inView:self.view delay:2];
    }
    else{
    preViewViewController*pre=[[preViewViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    pre._titlle=titleContent.text;
    pre._time=timeContent.text;
    pre._abstrct=abstractContent.text;
    pre._address=addressContent.text;
    pre._tel=telContent.text;
    pre._image= pickImage.image;
    [self.navigationController pushViewController:pre animated:YES];
    [pre release];

    }
}
-(void)clean:(NSNotification *)notification
{
    pickImage.image=nil;
    titleContent.text=@"";
    timeContent.text=@"";
    abstractContent.text=@"";
    addressContent.text=@"";
    telContent.text=@"";

}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]];
    //自定义的navbar
    UIView*navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    backButton.frame=CGRectMake(0, 8, 60,30);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];

    //初始化tableview
    //设置tableview的背景颜色，ios6只能这么设定
    UIView* groundView = [[[UIView alloc]initWithFrame:addEventTableView.bounds] autorelease];
    UIImageView*back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addbackground.png"]];
    back.frame=groundView.bounds;
    [groundView addSubview:back];
    [back release];
    addEventTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320,  460+[Tools isIphone5]-44) style:UITableViewStyleGrouped];
    addEventTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    addEventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    addEventTableView.backgroundView=groundView;
    addEventTableView.delegate=self;
    addEventTableView.dataSource=self;
    [self.view addSubview:addEventTableView];
    [addEventTableView release];
  
    
   
    //在上传时，清除这页面的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clean:) name:@"cleanData" object:nil];
    
}
#pragma mark -UIImagePickerCOntrollerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    pickImage.image=image;
    [imagePicker dismissModalViewControllerAnimated:YES];
    
    
 }

//三个必需实现的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }
//    if (section==1) {
//        return 5;
//    }
    
    return 1;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 150;
    }
    else{
        return 45+([Tools isIphone5]/10);
    }
return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 5 ) {
        return 60;
    }
    else
    {
    
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5 ) {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 60)] autorelease];
        view.backgroundColor = [UIColor clearColor];
        
        //加上两个按钮，确定和预览
        UIButton*cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame=CGRectMake(20, 10, 70, 40);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
        cancelButton.titleLabel.font=[UIFont systemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelButton];
        
        UIButton*previewButton=[UIButton buttonWithType:UIButtonTypeCustom];
        previewButton.frame=CGRectMake(230,10, 70, 40);
        [previewButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        previewButton.titleLabel.font=[UIFont systemFontOfSize:18];
        [previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [previewButton addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:previewButton];
        
        return view;
    }
    return nil;
}
-(void)buttobClick:(UIButton*)sender
{
    ContentViewController*add=[[ContentViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    add.delegate=self;
    switch (sender.tag) {
        case 301:
        {
            add.navTitle=@"活动名称";
            add.tag=@"301";
            add.textView=@"请输入活动的标题...";
            break;
        }
        case 302:
        {
           add.navTitle=@"活动时间";
            add.tag=@"302";
      //      add.textView=@"2013年05月02日12时30分 － 2013年05月02日12时00分";
       
            break;
        }
        case 303:
        {
            add.navTitle=@"详细介绍";
            add.tag=@"303";
            add.textView=@"请输入详细介绍的内容...";
            break;
        }
        case 304:
        {
            add.navTitle=@"活动地址";
            add.tag=@"304";
            add.textView=@"请输入详细活动地址...";
            break;
        }
        case 305:
        {
            add.navTitle=@"联系方式";
            add.tag=@"305";
            add.textView=@"请输入活动的联系方式...";            
            break;
        }
            
        default:
            break;
    }
    [self.navigationController pushViewController:add animated:YES];
    [add release];
    
}
#pragma mark contentViewDelegate
- (void)ContentViewController:(ContentViewController *)controller addWithInfo:(NSString *)text withTag:(NSString*)tag
{
    switch ([tag intValue]) {
        case 301:
        {
            titleContent.text=text;
            break;
        }
        case 302:
        {
            timeContent.text=text;
            break;
        }
        case 303:
        {
            abstractContent.text=text;
            break;
        }
        case 304:
        {
            addressContent.text=text;
            break;
        }
        case 305:
        {
            telContent.text=text;
            break;
        }
            
        default:
            break;
    }


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[[UITableViewCell alloc]init]autorelease];
    cell.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentView.userInteractionEnabled=YES;
    //设置用户名和密码是lable，后面是textfield
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            updateImageButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [updateImageButton setBackgroundImage:[UIImage imageNamed:@"updateImage.png"] forState:UIControlStateNormal];
            updateImageButton.frame=CGRectMake(15, 10, 130, 130);
            [updateImageButton addTarget:self action:@selector(updateImage:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:updateImageButton];
            
            UIImageView*backImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed: @"noneImage1.png"]];
            backImageView.frame=CGRectMake(155, 10, 130, 130);
            [cell.contentView addSubview:backImageView];
            [backImageView release];

            pickImage=[[UIImageView alloc]init];
            pickImage.backgroundColor=[UIColor clearColor];
            pickImage.frame=CGRectMake(155, 10, 130, 130);
            [cell.contentView addSubview:pickImage];
            [pickImage release];
            
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            UIImageView*titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addeventTitle.png"]];
            titleImage.frame=CGRectMake(4, 12+[Tools isIphone5]/29, 20+[Tools isIphone5]/12, 20+[Tools isIphone5]/12);
            [cell.contentView addSubview:titleImage];
            [titleImage release];
            
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3, 8, 85, 30+[Tools isIphone5]/12)];
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.text=@"活动标题";
             titleLabel.textColor=[UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:0.9];
            titleLabel.font=[UIFont systemFontOfSize:16+[Tools isIphone5]/44];
            [cell.contentView addSubview:titleLabel];
            [titleLabel release];
            
            titleContent=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3+90, 3, 120, 40+[Tools isIphone5]/12)];
            titleContent.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:titleContent];
            [titleContent release];
           
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(12+30+[Tools isIphone5]/12+3+90+130, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"jt.png"];
            [cell.contentView addSubview:imageview];
            [imageview release];
            
            //在最上面加一个透明button
            UIButton*titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag=301;
            titleButton.backgroundColor=[UIColor clearColor];
            titleButton.frame=cell.contentView.frame;
            [titleButton addTarget:self action:@selector(buttobClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleButton];
            
            
        }
    }
        if (indexPath.section==2) {
            if (indexPath.row==0) {
            UIImageView*titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addeventTime.png"]];
            titleImage.frame=CGRectMake(4, 12+[Tools isIphone5]/29, 20+[Tools isIphone5]/12, 20+[Tools isIphone5]/12);
            [cell.contentView addSubview:titleImage];
            [titleImage release];
            
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3, 8, 80, 30+[Tools isIphone5]/12)];
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.text=@"活动时间";
           titleLabel.textColor=[UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:0.9];
          //  titleLabel.textColor=[UIColor redColor];
            titleLabel.font=[UIFont systemFontOfSize:16+[Tools isIphone5]/44];
            [cell.contentView addSubview:titleLabel];
            [titleLabel release];
            
            timeContent=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3+90, 3, 120, 40+[Tools isIphone5]/12)];
            timeContent.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:timeContent];
            [timeContent release];
            
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(12+30+[Tools isIphone5]/12+3+90+130, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"jt.png"];
            [cell.contentView addSubview:imageview];
            [imageview release];
            
            //在最上面加一个透明button
            UIButton*titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag=302;
            titleButton.backgroundColor=[UIColor clearColor];
            titleButton.frame=cell.contentView.frame;
            [titleButton addTarget:self action:@selector(buttobClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleButton];
            

        }
        }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            UIImageView*titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addeventTel.png"]];
            titleImage.frame=CGRectMake(4, 12+[Tools isIphone5]/29, 20+[Tools isIphone5]/12, 20+[Tools isIphone5]/12);
            [cell.contentView addSubview:titleImage];
            [titleImage release];
            
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3, 8, 80, 30+[Tools isIphone5]/12)];
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.text=@"联系方式";
            titleLabel.textColor=[UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:0.9];
            titleLabel.font=[UIFont systemFontOfSize:16+[Tools isIphone5]/44];
            [cell.contentView addSubview:titleLabel];
            [titleLabel release];
            
            telContent=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3+90, 3, 120, 40+[Tools isIphone5]/12)];
            telContent.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:telContent];
            [telContent release];
            
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(12+30+[Tools isIphone5]/12+3+90+130, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"jt.png"];
            [cell.contentView addSubview:imageview];
            [imageview release];
            
            //在最上面加一个透明button
            UIButton*titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag=305;
            titleButton.backgroundColor=[UIColor clearColor];
            titleButton.frame=cell.contentView.frame;
            [titleButton addTarget:self action:@selector(buttobClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleButton];
            
                    }
        }
    if (indexPath.section==4) {
        if (indexPath.row==0) {
            UIImageView*titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addeventAddress.png"]];
            titleImage.frame=CGRectMake(4, 12+[Tools isIphone5]/29, 20+[Tools isIphone5]/12, 20+[Tools isIphone5]/12);
            [cell.contentView addSubview:titleImage];
            [titleImage release];
            
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3, 8, 80, 30+[Tools isIphone5]/12)];
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.text=@"活动地址";
             titleLabel.textColor=[UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:0.9];
            titleLabel.font=[UIFont systemFontOfSize:16+[Tools isIphone5]/44];
            [cell.contentView addSubview:titleLabel];
            [titleLabel release];
            
            addressContent=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3+90, 3, 120, 40+[Tools isIphone5]/12)];
            addressContent.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:addressContent];
            [addressContent release];
            
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(12+30+[Tools isIphone5]/12+3+90+130, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"jt.png"];
            [cell.contentView addSubview:imageview];
            [imageview release];
            
            //在最上面加一个透明button
            UIButton*titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag=304;
            titleButton.backgroundColor=[UIColor clearColor];
            titleButton.frame=cell.contentView.frame;
            [titleButton addTarget:self action:@selector(buttobClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleButton];
            
        }
        }
    if (indexPath.section==5) {
        if (indexPath.row==0) {
           
            UIImageView*titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addeventAbstract.png"]];
            titleImage.frame=CGRectMake(4, 12+[Tools isIphone5]/29, 20+[Tools isIphone5]/12, 20+[Tools isIphone5]/12);
            [cell.contentView addSubview:titleImage];
            [titleImage release];
            
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3, 8, 80, 30+[Tools isIphone5]/12)];
            titleLabel.backgroundColor=[UIColor clearColor];
            titleLabel.text=@"详细介绍";
            titleLabel.textColor=[UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:0.9];
            titleLabel.font=[UIFont systemFontOfSize:16+[Tools isIphone5]/44];
            [cell.contentView addSubview:titleLabel];
            [titleLabel release];
            
            abstractContent=[[UILabel alloc]initWithFrame:CGRectMake(2+30+[Tools isIphone5]/12+3+90, 3, 120, 40+[Tools isIphone5]/12)];
            abstractContent.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:abstractContent];
            [abstractContent release];
            
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(12+30+[Tools isIphone5]/12+3+90+130, 10, 20, 20)];
            imageview.image=[UIImage imageNamed:@"jt.png"];
            [cell.contentView addSubview:imageview];
            [imageview release];
            
            //在最上面加一个透明button
            UIButton*titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag=303;
            titleButton.backgroundColor=[UIColor clearColor];
            titleButton.frame=cell.contentView.frame;
            [titleButton addTarget:self action:@selector(buttobClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleButton];
            
            
        }

        
    }
    return cell;
}
@end
