//
//  api.swift
//  fenzhi
//
//  Created by lvxin on 2017/9/10.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import Foundation

//        let  privkey = "-----BEGIN PRIVATE KEY-----\nMIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKz8AoHDUYwcr7Ql\nLow/7pQnZYxRTXJfioqGQq+fW/NNCPMgR/Vf3b7iQfnXCStZWdbLx05tuUy7oIRE\nOz6WrOSaSnmndi/3Awec2HHBliv6oyvvdfk+SfjVCx1t76vEY7t1ZK6GZyBjYRtm\nV7o3xteyxmTzIr6DPpF4avuTaWAfAgMBAAECgYA1Nv2Kb8ypXrXKpFmSeaRqXUhH\nB0fc9HlJLg5buplt2nfzWy3n1UsBCtejBTzj4gPaKSwx+10yttGlftv+4BllZBvq\n3UuG4uqj8Y7sRzQPCBAhik1EMGL5QqpWyOkJta5g7itLq797MYtJKcPjzRcGoUEb\nwZ7EWD2dUoN8QL5CQQJBAOMWJ5guVcXw6MVo3aI7MXsz0kziUa+9aB/09xerowbh\n7e9whUCoCvf6wdO4EXCAI5jRO0I+7c/6d0cRmiJERv8CQQDDAmfo7aucTz/XLv/w\nEIdGzQBWuQFSZcpsYlSrA1TAtKzRy3RD1v6M7bZEExMvpDarTMCEyKr2XJOU+ne5\nQwbhAkB3wDchCU4yE9isQaCe7JgrYCiGYtKw2jEOqR+kW96cwoe2vJ+IeRVPr+yG\nuYp4yRn8fFnDlWvTQUGlOKMPbvIBAkAPiE2GfAfDN3y6QwAXuvlLZmC0h5/XVEw/\nPcXIqUdC4iExxKbKEIHN79EosuxASzAfjMl4yhLz9IO8xgZrNy+BAkEApj3DpvaK\nUIUiZkx2KpEkRUy755zOxMSP1HUcXw2TxfSGzMAUs6pxS734yUUj/cL228/Y/nat\n1ev9yQpFc/TYhQ==\n-----END PRIVATE KEY-----\n";

let pubkey = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCs/AKBw1GMHK+0JS6MP+6UJ2WM\nUU1yX4qKhkKvn1vzTQjzIEf1X92+4kH51wkrWVnWy8dObblMu6CERDs+lqzkmkp5\np3Yv9wMHnNhxwZYr+qMr73X5Pkn41Qsdbe+rxGO7dWSuhmcgY2EbZle6N8bXssZk\n8yK+gz6ReGr7k2lgHwIDAQAB\n-----END PUBLIC KEY-----\n";

let BASER_API = "http://fenzhi.wchao.org"//线上域名

//let last_par = "&client=iphone&version="+St

//-------------------通用接口
let common_api = "/api/common?"
let getregionlist_api = "/api/getregionlist?"

//-------------------登陆注册

let login_api = "/api/user/login?"
let sms_api = "/api/sendsms?"
let register_api = "/api/user/register?"
let findpwd_api = "/api/user/findpwd?"
let info_api = "/api/user/info?"
//-------------------个人

let getfollowlist_api = "/api/user/getfollowlist?"//获取关注列表接口
let getfanslist_api = "/api/user/getfanslist?"//获取区域列表接口
let getschoollist_api = "/api/getschoollist?"//获取学校列表接口
let getbooklist_api = "/api/getbooklist?"//获取教材列表接口
let getfavoritelist_api = "/api/user/getfavoritelist?"//获取收藏列表接口
let getzanlist_api = "/api/user/getzanlist?"//获取赞赏列表接口
