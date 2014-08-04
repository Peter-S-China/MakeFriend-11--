//
//  EditPersonInfoViewController.m
//  MakeFriend
//
//  Created by dianji on 13-9-2.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "EditPersonInfoViewController.h"
#import "CJSONDeserializer.h"
#import "PhotoInfo.h"
#import "UIButton+WebCache.h"
#import "ASIFormDataRequest.h"
#import "EditPassWordViewController.h"
@interface EditPersonInfoViewController ()

@end

@implementation EditPersonInfoViewController
@synthesize selctedImage,_personInfo;
//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
/*
-(void)loadDataByUserName
{
    NSUserDefaults *defaut=[NSUserDefaults standardUserDefaults];
    NSString *userName=[defaut objectForKey:@"PHONE_NUMBER"];
   
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?load_users='dd'&username=%@",userName]]];
    [request startAsynchronous];
    NSLog(@"http://218.246.35.203:8011/pages/json.aspx?load_users='dd'&username=%@",userName);
    [request setFailedBlock:^{
        NSLog(@"request info failed");
    }];
    
    [request setCompletionBlock:^{
        __autoreleasing NSError *error = nil;
        CJSONDeserializer *deseri = [CJSONDeserializer deserializer];
        deseri.nullObject = @"";
        NSArray *momentArray = [deseri deserializeAsArray:request.responseData error:&error];
        NSLog(@"momentArray = %@",momentArray);
        
        if ([momentArray isKindOfClass:[NSArray class]] && [momentArray count] > 0) {
            NSLog(@"%i",[momentArray count]);
            for (NSDictionary *dic in momentArray) {
                nickNameText.text = [dic objectForKey:@"user_nickname"];
                [litleImageBut setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"user_picid"]]];
                birthText.text=[dic objectForKey:@"user_birth"];
                sexText.text=[dic objectForKey:@"user_sex"];
                signatureText.text=[dic objectForKey:@"user_defwish"];
                addressText.text=[dic objectForKey:@"user_address"];
                
            }
                

            }
          
        
    }];


}*/
-(void)exitButtonClicked:(id)sender
{
    exit(0);
    
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
-(void)editPasswordClicked:(UIButton *)sender
{
    EditPassWordViewController *epc=[[EditPassWordViewController alloc]init];
    [self.navigationController pushViewController:epc animated:YES];
    [epc release];
}
-(void)creatPersonalView
{
    //scrollview
    UIScrollView*backScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)];
    backScroll.backgroundColor=[UIColor whiteColor];
    backScroll.contentSize=CGSizeMake(320, 568);
    [self.view addSubview:backScroll];
    [backScroll release];
 
    
    //头像栏
    UIView *headImage=[[UIView alloc]initWithFrame:CGRectMake(15, 50, 290, 40)];
    headImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"headImageBack.png"]];
    [backScroll addSubview:headImage];
    [headImage release];
    //创建照片选择按钮
    UIImageView*photoBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(230, 15, 58, 60)];
    photoBackImage.userInteractionEnabled=YES;
    photoBackImage.image=[UIImage imageNamed:@"takePhoto.png"];
    [backScroll addSubview:photoBackImage];
    [photoBackImage release];
    
    litleImageBut=[UIButton buttonWithType:UIButtonTypeCustom];
    litleImageBut.frame=CGRectMake(2, 2, 54, 52);
     [litleImageBut setImageWithURL:[NSURL URLWithString:self._personInfo.useraLitleImageURL]];
    [litleImageBut addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoBackImage addSubview:litleImageBut];
    //昵称，生日，性别
    
    UIView *nickBirthSex=[[UIView alloc]initWithFrame:CGRectMake(15, 110, 290, 122)];
    nickBirthSex.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"nickBirthSex.png"]];
    [backScroll addSubview:nickBirthSex];
    [nickBirthSex release];
    
    nickNameText=[[UITextField alloc]initWithFrame:CGRectMake(100, 125, 200, 25)];
    nickNameText.backgroundColor=[UIColor clearColor];
    nickNameText.textAlignment=NSTextAlignmentRight;
    nickNameText.text =self._personInfo.userName;
    nickNameText.textColor=[UIColor blackColor];
    nickNameText.font=[UIFont systemFontOfSize:14];
    nickNameText.delegate=self;
    [backScroll addSubview:nickNameText];
    [nickNameText release];
    
    birthText=[[UITextField alloc]initWithFrame:CGRectMake(100, 165, 200, 25)];
    birthText.backgroundColor=[UIColor clearColor];
    birthText.textAlignment=NSTextAlignmentRight;
    birthText.text=self._personInfo.userBirth;
    birthText.textColor=[UIColor blackColor];
    birthText.delegate=self;
    birthText.font=[UIFont systemFontOfSize:14];
    [backScroll addSubview:birthText];
    [birthText release];
    
    sexText=[[UITextField alloc]initWithFrame:CGRectMake(100, 205, 200, 25)];
    sexText.backgroundColor=[UIColor clearColor];
    sexText.textAlignment=NSTextAlignmentRight;
    sexText.text=self._personInfo.userSex;
    sexText.textColor=[UIColor blackColor];
    sexText.delegate=self;
    sexText.font=[UIFont systemFontOfSize:14];
    [backScroll addSubview:sexText];
    [sexText release];
    //个性签名
    UIView *signatureView=[[UIView alloc]initWithFrame:CGRectMake(15, 252, 290, 80)];
    signatureView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"signatureView.png"]];
    [backScroll addSubview:signatureView];
    [signatureView release];
    
    addressText=[[UITextField alloc]initWithFrame:CGRectMake(100, 305-40, 200, 25)];
    addressText.backgroundColor=[UIColor clearColor];
    addressText.textAlignment=NSTextAlignmentRight;
    addressText.textColor=[UIColor blackColor];
    addressText.text=self._personInfo.userAddress;
    addressText.delegate=self;
    addressText.tag=101;
    addressText.font=[UIFont systemFontOfSize:14];
    [backScroll addSubview:addressText];
    [addressText release];
    
    signatureText=[[UITextField alloc]initWithFrame:CGRectMake(100, 305, 200, 25)];
    signatureText.backgroundColor=[UIColor clearColor];
    signatureText.textAlignment=NSTextAlignmentRight;
    signatureText.textColor=[UIColor blackColor];
    signatureText.text=self._personInfo.userSignature;
    signatureText.delegate=self;
    signatureText.tag=102;
    signatureText.font=[UIFont systemFontOfSize:14];
    [backScroll addSubview:signatureText];
    [signatureText release];    //退出登陆
  //修改密码
    UIView *editPasswordView=[[UIView alloc]initWithFrame:CGRectMake(15, 355, 290, 40)];
    editPasswordView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"editPasswordView.png"]];
    [backScroll addSubview:editPasswordView];
    [editPasswordView release];
    
    UIButton *editPasswordBut=[UIButton buttonWithType:UIButtonTypeCustom];
    editPasswordBut.frame=CGRectMake(15, 355, 290, 40);
    editPasswordBut.backgroundColor=[UIColor clearColor];
    [editPasswordBut addTarget:self action:@selector(editPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backScroll addSubview:editPasswordBut];
    
    UIButton*exitBut=[UIButton buttonWithType:UIButtonTypeCustom];
    exitBut.frame=CGRectMake(15, backScroll.contentSize.height-60, 290, 40);
    [exitBut setImage:[UIImage imageNamed:@"exitBut.png"] forState:UIControlStateNormal];
    [exitBut addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backScroll addSubview:exitBut];
}
-(void)backButtonClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)sendButtonClicked:(UIButton*)sender
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
    [request setPostValue:[NSString stringWithFormat:@"%@",nickNameText.text] forKey:@"nickname"];
    [request setPostValue:[NSString stringWithFormat:@"%@",birthText.text] forKey:@"birthday"];
    [request setPostValue:[NSString stringWithFormat:@"%@",sexText.text] forKey:@"usersex"];
    [request setPostValue:@"1" forKey:@"public"];
    [request setPostValue:[NSString stringWithFormat:@"%@",addressText.text] forKey:@"useraddress"];
    [request setPostValue:[NSString stringWithFormat:@"%@",signatureText.text] forKey:@"signname"];
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title=@"修改个人信息";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(5, 8, 12,15);
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    UIButton*right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake(5, 8, 18,15);
    [right addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item2;
    [item2 autorelease];
    
    [self creatPersonalView];
//[self loadDataByUserName];
}


#pragma mark--uitextFieldDelegate
//当敲打回车键时，开始搜索并收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
 /*
    if (textField.tag==101) {
        
    [UIView animateWithDuration:0.1 animations:^{
        textField.backgroundColor=[UIColor clearColor];
        CGRect rect = textField.frame;
        rect.origin.y =305;
        rect.origin.x=100;
        rect.size.width=200;
        
        textField.frame = rect;
        
    }
                     completion:^(BOOL finished) {
                     }];
    }*/
    if (textField.tag==102) {
        
        [UIView animateWithDuration:0.1 animations:^{
            textField.backgroundColor=[UIColor clearColor];
            CGRect rect = textField.frame;
            rect.origin.y =305;
            rect.origin.x=100;
            rect.size.width=200;
            
            textField.frame = rect;
            
        }
                         completion:^(BOOL finished) {
                         }];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text=@"";
  
    NSLog(@"textfild max Y:%f",CGRectGetMaxY(textField.frame));
    if (textField.tag==102){//上移
        [UIView animateWithDuration:0.1 animations:^{
            textField.backgroundColor=[UIColor whiteColor];
            CGRect rect = textField.frame;
            rect.origin.y =480-216;
            rect.origin.x=0;
            rect.size.width=320;
    
            textField.frame = rect;
            
        }
                         completion:^(BOOL finished) {
                         }];
        
        
    }

 
    return YES;
}
-(void)saveImage:(UIImage *) image
{
    [litleImageBut setImage:image forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
