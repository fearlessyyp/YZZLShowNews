//
//  DataBaseHandle.m
//  ShowNews
//
//  Created by YYP on 16/7/2.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#import "DataBaseHandle.h"

@implementation DataBaseHandle
#pragma mark - 声明单例
singleton_implementation(DataBaseHandle)

#pragma mark - News转换成AVObject
- (AVObject *)newsToAVObject:(News *)news {
    AVObject *ob = [[AVObject alloc] initWithClassName:@"News"];
    [ob setObject:news.postid forKey:@"postid"];
    [ob setObject:news.title forKey:@"title"];
    [ob setObject:news.skipID forKey:@"skipID"];
    [ob setObject:news.skipType forKey:@"skipType"];
    [ob setObject:news.imgsrc forKey:@"imgsrc"];
    [ob setObject:news.source forKey:@"source"];
    [ob setObject:news.imgextra forKey:@"imgextra"];
    [ob setObject:[AVUser currentUser].username forKey:@"username"];
    return ob;
}

#pragma mark - AVObject转换成转换成News
- (News *)aVObjectToNews:(AVObject *)object {
    News *news = [[News alloc] init];
    news.postid = [object objectForKey:@"postid"];
    news.title = [object objectForKey:@"title"];
    news.skipID = [object objectForKey:@"skipID"];
    news.skipType = [object objectForKey:@"skipType"];
    news.imgextra = [object objectForKey:@"imgextra"];
    news.source = [object objectForKey:@"source"];
    news.imgsrc = [object objectForKey:@"imgsrc"];
    return news;
}

#pragma mark - Video转换成AVObject
- (AVObject *)videoToAVObject:(VideoModel *)video {
    AVObject *ob = [[AVObject alloc] initWithClassName:@"VideoModel"];
    [ob setObject:video.title forKey:@"title"];
    [ob setObject:video.cover forKey:@"cover"];
    [ob setObject:@(video.length) forKey:@"length"];
    [ob setObject:video.mp4_url forKey:@"mp4_url"];
    [ob setObject:video.topicName forKey:@"topicName"];
    [ob setObject:video.topicImg forKey:@"topicImg"];
    [ob setObject:[AVUser currentUser].username forKey:@"username"];
    return ob;
}

#pragma mark -AVObject转换成Video
- (VideoModel *)aVObjectToVideoModel:(AVObject *)object
{
    VideoModel *model = [[VideoModel alloc] init];
    model.title = [object objectForKey:@"title"];
    model.cover = [object objectForKey:@"cover"];
    model.length = [[object objectForKey:@"length"] integerValue];
    model.mp4_url = [object objectForKey:@"mp4_url"];
    model.topicName = [object objectForKey:@"topicName"];
    model.topicImg = [object objectForKey:@"topicImg"];
    return model;
    
}

#pragma mark - Music转换成AVObject
- (AVObject *)musicTOAVObject:(Music *)music {
    AVObject *ob = [[AVObject alloc] initWithClassName:@"Music"];
    [ob setObject:music.musicName forKey:@"musicName"];
    [ob setObject:music.singerName forKey:@"singerName"];
    [ob setObject:music.specialName forKey:@"specialName"];
    [ob setObject:music.ID forKey:@"ID"];
    [ob setObject:music.mp3Url forKey:@"mp3Url"];
    [ob setObject:music.picUrl forKey:@"picUrl"];
    [ob setObject:music.duration forKey:@"duration"];
    [ob setObject:music.lyricxxxx forKey:@"lyricxxxx"];
    [ob setObject:[AVUser currentUser].username forKey:@"username"];
    return ob;
}

#pragma mark - AVObject转换成转换成Music
- (Music *)aVObjectToMusic:(AVObject *)object {
    Music *music = [[Music alloc] init];
    music.musicName = [object objectForKey:@"musicName"];
    music.singerName = [object objectForKey:@"singerName"];
    music.specialName = [object objectForKey:@"specialName"];
    music.ID = [object objectForKey:@"ID"];
    music.mp3Url = [object objectForKey:@"mp3Url"];
    music.picUrl = [object objectForKey:@"picUrl"];
    music.duration = [object objectForKey:@"duration"];
    music.lyricxxxx = [object objectForKey:@"lyricxxxx"];
    return music;
}



@end
