# LyListManager
对 MJRefresh 的下拉上拉数据的分页逻辑做了统一封装，用一个  对象来统一做数据处理，将分页请求用delegate移到外部。


项目中有很多地方用到了分页请求数据，项目中的小伙伴们都在各自的类中创建pageNo和pageCount来做数据请求，

花了2个小时帮小伙伴们做了个简单封装，来统一分页逻辑的处理。如有不正确的地方，希望能给我留言。谢谢大家！！


# 使用
1. 将LyListManger.h LyListManager.m 文件加入到项目中（MJRefresh这里不做引入了，可以直接引入MJRefresh的源码，也可以用Pods，也可以用其他的上啦下啦UI封装）
2. 生产 LyListManager 对象，因为我的项目中都是用UITableView对象来显示数据，所以我弱引用了一个UITableView对象；
3. 实现数据请求回掉即可
4. 另外增加了数据请求开始、失败、结束的回调（可选的）

# --
最初想做到MJRefresh框架里，后来细想一下不应该跟UI绑定。现在的这种做法，即使更换UI框架应该也只需要修改几行代码就可以了！
