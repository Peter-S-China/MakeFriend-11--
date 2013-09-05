//
//  FillPersonMessageViewController.m
//  MakeFriend
//
//  Created by dianji on 13-8-28.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "FillPersonMessageViewController.h"
#import "ASIFormDataRequest.h"
@interface FillPersonMessageViewController ()

@end

@implementation FillPersonMessageViewController
@synthesize selctedImage;
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[MyTableBarController sharedTabBarController].navigationController setNavigationBarHidden:YES];
    
}
-(void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)rightButtonClicked:(id)sender
{
    //把头像和昵称传给后台
    //获取用户名username
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString*PhoneNum=[defaults objectForKey:@"PHONE_NUMBER"];
    NSLog(@".....PhoneNum.....%@",PhoneNum);
    //获取图片data
    UIImage* theImage = [Tools imageWithImageSimple:self.selctedImage scaledToSize:CGSizeMake(200.0, 300.0)];
    NSData *imageData = UIImageJPEGRepresentation(theImage, 0.8);
    
    NSString*url=@"http://218.246.35.203:8011/pages/json.aspx?setuserinfor='aa'";
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL: [NSURL URLWithString:url]];
    [request addData:imageData forKey:@"userinfor"];
    [request setPostValue:[NSString stringWithFormat:@"%@",PhoneNum] forKey:@"username"];
    [request setPostValue:[NSString stringWithFormat:@"%@",nickTextFild.text] forKey:@"nickname"];
    [request setPostValue:@"1992-02-20" forKey:@"birthday"];
    [request setPostValue:@"1" forKey:@"public"];
    
    [request setDelegate:self];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"已经提交到后台进行审核，请耐心等候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        [alter release];
        
        
    }];
    [request setFailedBlock:^{
        NSLog(@"asi error: %@",request.error.debugDescription);
        [Tools showPrompt:@"上传超时，请点击上传按钮再试一次，谢谢你的配合" inView:self.view delay:0.5];
        
    }];
    
    [request buildRequestHeaders];
    [request startAsynchronous];
    NSLog(@"responseString = %@", request.responseString);
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController: [MyTableBarController sharedTabBarController] animated:YES];

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
-(void)exitButtonClicked:(id)sender
{
 exit(0);

}
-(void)creatView
{
    UIView *headImage=[[UIView alloc]initWithFrame:CGRectMake(15, 50, 290, 40)];
    headImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"headImageBack.png"]];
    [self.view addSubview:headImage];
    [headImage release];
    //创建照片选择按钮
    UIImageView*photoBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(230, 15, 58, 60)];
    photoBackImage.userInteractionEnabled=YES;
    photoBackImage.image=[UIImage imageNamed:@"takePhoto.png"];
    [self.view addSubview:photoBackImage];
    [photoBackImage release];
    
    takePhoto=[UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame=CGRectMake(2, 2, 54, 52);
    [takePhoto setImage:nil forState:UIControlStateNormal];
    [takePhoto addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoBackImage addSubview:takePhoto];

 //创建昵称，并在上面加上textfild
    UIView *nickNameView=[[UIView alloc]initWithFrame:CGRectMake(15, 120, 290, 40)];
    nickNameView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"nikeNameBack.png"]];
    [self.view addSubview:nickNameView];
    [nickNameView release];
    //设置可填写框textfield
    nickTextFild=[[UITextField alloc]initWithFrame:CGRectMake(90, 10, 150, 30)];
    nickTextFild.backgroundColor=[UIColor clearColor];
    nickTextFild.delegate=self;
    //对齐
    nickTextFild.textAlignment=0;
    nickTextFild.placeholder=@"为自己填写昵称吧";
    nickTextFild.font=[UIFont systemFontOfSize:14];
    [nickNameView addSubview:nickTextFild];
    [nickTextFild release];
//退出登陆
    UIButton*exitBut=[UIButton buttonWithType:UIButtonTypeCustom];
    exitBut.frame=CGRectMake(15, self.view.bounds.size.height-100, 290, 40);
    [exitBut setImage:[UIImage imageNamed:@"exitBut.png"] forState:UIControlStateNormal];
    [exitBut addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBut];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"填写个人信息";
    self.view.backgroundColor=[UIColor blackColor];
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(5, 8, 15,15);
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    UIButton*right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake(5, 8, 18,15);
    [right addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item2;
    [item2 autorelease];
 //创建view内容
    [self creatView];
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
        self.selctedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //图片存入相册
        //      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self saveImage:self.selctedImage];
    }
    else
    {
        self.selctedImage= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        [self saveImage:self.selctedImage];
        
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
        
        NSLog(@"  ————拍照完成————  ");
    }];
}
#pragma mark--textfieldDelegate
//当敲打回车键时，开始搜索并收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
