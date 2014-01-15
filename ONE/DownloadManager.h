//
//  DownloadManager.h
//  MusicPlayer2
//
//  Created by Liang Wei on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MessageInfo.h"

//创建的一个单列，可以记录所有数据
@interface DownloadManager : NSObject
{
    //为了多个一起下载，并且可以知道停止的是哪一个
    ASINetworkQueue *_queue;
}

@property (nonatomic, retain) NSMutableArray *downloadArray;
@property (nonatomic, copy) NSString *currentPlayName;
@property(nonatomic,retain)NSMutableDictionary*musicDictionary;

+ (DownloadManager *)sharedDownloadManager;
- (void)addRequest:(MessageInfo *)messageinfo;
- (void)pause:(MessageInfo *)Messageinfo;
- (void)updateProgress:(MessageInfo *)cell music:(MessageInfo *)Messageinfo;


@end
