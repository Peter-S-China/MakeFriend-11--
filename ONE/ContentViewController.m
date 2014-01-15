//
//  ContentViewController.m
//  ONE
//
//  Created by dianji on 13-5-10.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "ContentViewController.h"
#import "RegexKitLite.h"
@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize navTitle;
@synthesize tag;
@synthesize delegate;
@synthesize textView;

-(void)dealloc
{
    [yearArray release];
    [monthArray release];
    [dayArray release];
    [hourArray release];
    [miniteArray release];
    
    [super dealloc];
    
}
-(void)backButtonClicked:(UIButton*)sender
{
    if ([self.tag intValue]==305) {
        if ([self isMobileNumber:textView2.text]) {
            if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
                [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
            }
            
        }
        else if ([textView2.text hasPrefix:@"请"])
        {
          textView2.text=@"";
            if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
                [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
            }
        }
        else
        {
            [Tools showPrompt:@"请检查你的手机号是否正确" inView:self.view delay:2];
            [textView2 resignFirstResponder];
            return;
        }
    }
    if ([self.tag intValue]==302) {//时间选择
        if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
            [delegate ContentViewController:self addWithInfo:[NSString stringWithFormat:@"%@ - %@",startTexview.text,endTexview.text] withTag:self.tag];
        }
    }
    else{
        if ([textView2.text hasPrefix:@"请"]) {
            textView2.text=@"";
            if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
                [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
            }
        }
        else
        {
            if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
                [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
            }
        }
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//放下pickerView
- (void)hidePickerView
{
	[UIView beginAnimations:@"AnimationDOWN" context:nil];
	[UIView setAnimationDuration:0.3];
	_timeView.frame = CGRectMake(0, 460+[Tools isIphone5], 320, 260);
	[UIView commitAnimations];
}

//调出pickerView
- (void)showPickerView
{
	[UIView beginAnimations: @"AnimationUP" context:nil];
	[UIView setAnimationDuration:0.3];
	_timeView.frame = CGRectMake(0, 206+[Tools isIphone5], 320, 260);
	[UIView commitAnimations];
}

//点击完成
- (void)choosePickerDone
{
    [UIView beginAnimations:@"AnimationDOWN" context:nil];
	[UIView setAnimationDuration:0.3];
	_timeView.frame = CGRectMake(0, 460+[Tools isIphone5], 320, 260);
	   
}

-(void)startTimeButtonClicked:(UIButton*)sender
{
    if (sender.tag==500) {
        _whitchPicker=0;
        [_pickerView reloadAllComponents];
        [self showPickerView];
    }
    

}
-(void)endTimeButtonClicked:(UIButton*)sender
{
    if (sender.tag==501) {
        _whitchPicker=1;
        [_pickerView reloadAllComponents];
        [self showPickerView];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 //获取当前时间
    NSDate *  senddate=[NSDate date];
    NSDate *afterdata=[NSDate dateWithTimeIntervalSinceNow:24*60*60];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日HH时mm分"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString *  onedayAfterString=[dateformatter stringFromDate:afterdata];
  //初始化控件
    if ([self.tag intValue]==302) {
        textView2.hidden=YES;
        UILabel*startLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 80, 80, 30)];
        startLabel.text=@"开始时间:";
        startLabel.backgroundColor=[UIColor clearColor];
        startLabel.textColor=[UIColor whiteColor];
        [self.view addSubview:startLabel];
        [startLabel release];
        
        startTexview=[[UITextView alloc]initWithFrame:CGRectMake(110, 80, 200, 30)];
        startTexview.backgroundColor=[UIColor whiteColor];
        startTexview.font=[UIFont systemFontOfSize:14];
        startTexview.text=locationString;
        [self.view addSubview:startTexview];
        [startTexview release];
        //加上透明按钮
        startTimeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        startTimeButton.frame=CGRectMake(30, 80, 280, 30);
        startTimeButton.backgroundColor=[UIColor clearColor];
        [startTimeButton addTarget:self action:@selector(startTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        startTimeButton.tag=500;
        [self.view addSubview:startTimeButton];
        
        UILabel*endLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 130, 80, 30)];
        endLabel.text=@"结束时间:";
        endLabel.backgroundColor=[UIColor clearColor];
        endLabel.textColor=[UIColor whiteColor];
        [self.view addSubview:endLabel];
        [endLabel release];
        
        endTexview=[[UITextView alloc]initWithFrame:CGRectMake(110, 130, 200, 30)];
        endTexview.backgroundColor=[UIColor whiteColor];
        endTexview.font=[UIFont systemFontOfSize:14];
        endTexview.text=onedayAfterString;
        [self.view addSubview:endTexview];
        [endTexview release];
        //加上透明按钮
        endTimeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        endTimeButton.frame=CGRectMake(30, 130, 280, 30);
        endTimeButton.backgroundColor=[UIColor clearColor];
        [endTimeButton addTarget:self action:@selector(endTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        endTimeButton.tag=501;
        [self.view addSubview:endTimeButton];
 
        
        
    }
//    else
//    {
//     [textView2 becomeFirstResponder];    
//    }
    
}

-(BOOL)isMobileNumber:(NSString*)mobileNum
{
    
    return [mobileNum isMatchedByRegex:@"^1[0-9]{10}$"];
    
}


-(void)chooseDone
{
    
    if ([self.tag intValue]==305) {
        if ([self isMobileNumber:textView2.text]) {
            if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
                [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
            }
 
        }
        else
        {
            [Tools showPrompt:@"请检查你的手机号是否正确" inView:self.view delay:2];
            [textView2 resignFirstResponder];
            return;
        }
    }
   else{
        if ([textView2.text hasPrefix:@"请"]) {
            textView2.text=@"";
            if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
                [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
               }
        }
        else
        {
        if (delegate && [delegate respondsToSelector:@selector(ContentViewController:addWithInfo:withTag:)]) {
            [delegate ContentViewController:self addWithInfo:textView2.text withTag:self.tag];
            }
        }
    }
        
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)creatTextFiled
{
    textView2=[[UITextView alloc]initWithFrame:CGRectMake(10, 55, 300, 80)];
    textView2.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView2.font=[UIFont systemFontOfSize:18];
    textView2.textColor=[UIColor grayColor];
    textView2.text=self.textView;

    
    UIToolbar *keybordBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, 320, 44)];
    keybordBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(chooseDone)];
    keybordBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem, nil];
    [spaceButtonItem release];
    [hiddenButtonItem release];
    
    textView2.inputAccessoryView=keybordBar;
    [keybordBar release];
    textView2.delegate=self;
    [self.view addSubview:textView2];
    [textView2 release];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]];
    //自定义的navbar
    UIView*navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"保存" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    backButton.frame=CGRectMake(0, 8, 80,30);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UILabel*navtitle=[[UILabel alloc]initWithFrame:CGRectMake(130, 3, 100, 40)];
    navtitle.backgroundColor=[UIColor clearColor];
    navtitle.text=self.navTitle;
    navtitle.textColor=[UIColor whiteColor];
    navtitle.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [navView addSubview:navtitle];
    [navtitle release];
    [self creatTextFiled];
    
    
//初始化picker
    
    //初始化选取器
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 460+[Tools isIphone5], 320, 260)];
    UIToolbar *keybordBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, 320, 44)];
    keybordBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(hidePickerView)];
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(choosePickerDone)];
    keybordBar.items = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,hiddenButtonItem, nil];
    [_timeView addSubview:keybordBar];
    [spaceButtonItem release];
    [cancelButtonItem release];
    [hiddenButtonItem release];
    [keybordBar release];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [_timeView addSubview:_pickerView];
    [self.view addSubview:_timeView];
    [_timeView release];
    [_pickerView release];
    yearArray=[[NSArray arrayWithObjects:@"",@"2013年",@"2014年",@"2015年",@"2016年",@"2017年",@"2018年",@"2019年",@"2020年",@"2021年", nil]retain];
    monthArray=[[NSArray arrayWithObjects:@"",@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月", nil] retain];
    dayArray=[[NSArray arrayWithObjects:@"",@"01日",@"02日",@"03日",@"04日",@"05日",@"06日",@"07日",@"08日",@"09日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日", nil] retain];
    hourArray=[[NSArray arrayWithObjects:@"",@"01时",@"02时",@"03时",@"04时",@"05时",@"06时",@"07时",@"08时",@"09时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时",@"24时", nil] retain];
    miniteArray=[[NSArray arrayWithObjects:@"",@"00分",@"10分",@"20分",@"30分",@"40分",@"50分", nil]retain];
}
#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UIView *v=[[UIView alloc]
               initWithFrame:CGRectMake(0,0,
                                        [self pickerView:pickerView widthForComponent:component],
                                        [self pickerView:pickerView rowHeightForComponent:component])];
	[v setOpaque:TRUE];
	[v setBackgroundColor:[UIColor clearColor]];
    UILabel *lbl=nil;
    lbl= [[UILabel alloc]
          initWithFrame:CGRectMake(8,0,
                                   [self pickerView:pickerView widthForComponent:component]-16,
                                   [self pickerView:pickerView rowHeightForComponent:component])];
	[lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
	NSString *ret=@"";
    
	switch (component) {
		case 0:
        {
			ret=[yearArray objectAtIndex:row];
			break;
        }
		case 1:
        {
            ret=[monthArray objectAtIndex:row];
			break;
        }
	    case 2:
        {
            ret=[dayArray objectAtIndex:row];
			break;
        }
        case 3:
        {
            ret=[hourArray objectAtIndex:row];
			break;
        }
        case 4:
        {
            ret=[miniteArray objectAtIndex:row];
			break;
        }
    }
    
	lbl.text=ret;
	[lbl setFont:[UIFont boldSystemFontOfSize:14]];
    [v addSubview:lbl];
    [lbl release];
    return [v autorelease];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    
    switch (component) {
        case 0:
        {
            year=[yearArray objectAtIndex:row];
            break;
        }
        case 1:
        {
            month=[monthArray objectAtIndex:row];
            break;
        }
        case 2:
        {
            day=[dayArray objectAtIndex:row];
            break;
        }
        case 3:
        {
            hour=[hourArray objectAtIndex:row];
            break;
        }
        case 4:
        {
            minite=[miniteArray objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    if (_whitchPicker==0) {
       startTexview.text=[NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minite]; 
    }
  else
  {
      endTexview.text=[NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minite];}
    NSLog(@"%@",startTexview.text);
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	float ret=50;
	switch (component) {
		case 0:
        {
            ret=90;
			break;
        }
		default:
			break;
	}
	return ret;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return [yearArray count];
		case 1:
			return [monthArray count];
        case 2:
            return [dayArray count];
        case 3:
            return [hourArray count];
        case 4:
            return [miniteArray count];
		default:
			return 1;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
   textView2.text=@"";

}
@end
