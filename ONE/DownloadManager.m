//
//  DownloadManager.m
//  MusicPlayer2
//
//  Created by Liang Wei on 10/4/12.
//
//

#import "DownloadManager.h"

@implementation DownloadManager

@synthesize downloadArray,currentPlayName,musicDictionary;

static DownloadManager *sharedDownloadManager = nil;

- (void)dealloc
{
    [musicDictionary release];
    [downloadArray release];
    [currentPlayName release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[ASINetworkQueue alloc] init];
        [_queue setShowAccurateProgress:YES];
        [_queue go];
        self.downloadArray = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

+ (DownloadManager *)sharedDownloadManager
{
    @synchronized(self)//同步
    {
        if (!sharedDownloadManager) {
            sharedDownloadManager = [[self alloc] init];
        }
    }
    return sharedDownloadManager;
}
//支持多个一起下载
- (void)addRequest:(MessageInfo *)Messageinfo
{
    NSString *temppath = [NSString stringWithFormat:@"%@/%@ - %@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Message"],Messageinfo.title,nil];
    NSString *savePath = [NSString stringWithFormat:@"%@/%@ - %@.mp3",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Message"],nil,nil];
    NSString *PhotoPath = [NSString stringWithFormat:@"%@/%@ - %@.txt",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Message"],nil,nil];
//下载photoURL
    ASIHTTPRequest*photoRequest=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:Messageinfo.photoURL]];
 //下载  
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:nil]];
 //是否可以断点续传，下次运行可以继续下载
    [request setAllowResumeForFileDownloads:YES];
    [request setTemporaryFileDownloadPath:temppath];
    [request setDownloadDestinationPath:savePath];
    [photoRequest setDownloadDestinationPath:PhotoPath];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:music.authorImageUrl forKey:@"info"];
    [request setUserInfo:userInfo];
    request.delegate = self;
    
    [_queue addOperation:request];
    [_queue addOperation:photoRequest];
    [request release];
}
//暂停当前点击的下载
- (void)pause:(Music *)music
{
    for (ASIHTTPRequest *request in [_queue operations]) {
        NSString *url = [request.userInfo objectForKey:@"info"];//查看userinfo信息
        if ([MessageInfo. isEqualToString:url]) {//判断ID是否匹配
            //暂停匹配对象
            [request setDownloadProgressDelegate:nil];
            [request clearDelegatesAndCancel];
        }
    }
}

- (void)updateProgress:(downloadCell *)cell music:(MessageInfo *)Messageinfo
{
    for (ASIHTTPRequest *request in [_queue operations]) {
        NSString *url = [request.userInfo objectForKey:@"info"];//查看userinfo信息
        if ([Messageinfo.photoURL isEqualToString:url]) {//判断ID是否匹配
            [request setDownloadProgressDelegate:cell];
        }
    }

}

@end
