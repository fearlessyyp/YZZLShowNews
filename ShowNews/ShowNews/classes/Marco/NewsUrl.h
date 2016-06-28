//
//  NewsUrl.h
//  ShowNews
//
//  Created by LK on 16/6/24.
//  Copyright © 2016年 YZZL. All rights reserved.
//

#ifndef NewsUrl_h
#define NewsUrl_h

// /视频列表的URL
#define NEWS_VIDEO_LIST_URL @"http://c.m.163.com/nc/video/list/V9LG4B3A0/n/0-10.html"

// / 视频下拉刷新
#define NES_VIDEO_DOWN_URL(page) [NSString stringWithFormat:@"http://c.m.163.com/nc/video/list/V9LG4B3A0/n/%ld-10.html", page] 

// 音乐搜索的URL
#define NEWS_MUSIC_SEARCH_URL231 @"http://s.music.qq.com/fcgi-bin/music_search_new_platform?t=0&n=20&aggr=1&cr=1&loginUin=0&format=json&inCharset=GB2312&outCharset=utf-8&notice=0&platform=jqminiframe.json&needNewCode=0&p=1&catZhida=0&remoteplace=sizer.newclient.next_song&w=%@"
// 音乐播放的URL
#define NEWS_MUSIC_PLAY_URL @"http://cc.stream.qqmusic.qq.com/C200%@.m4a?vkey=F64F40C201D549FECA435C42C83F0C74AAA41F6EA4788517BB975D4CD90F51C0712D5CAAC0768BBE1CB19434CABFF55F13924A2FF7A70D8C&fromtag=0"



#pragma mark - 获取城市列表
#define WEATHER_ALLCITY @"https://api.heweather.com/x3/citylist?search=allchina&key=741e9450a52942b8aecf694beeda6b7e"

#pragma mark - 获取某个城市当前天气
#define WEATHER_NOW_CITY(cityId) [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?cityid=%@&key=741e9450a52942b8aecf694beeda6b7e", cityID]


#endif /* NewsUrl_h */
