# HashMap，ArrayMap，SparseArray性能对比

ArrayMap及SparseArray是android的系统API，是专门为移动设备而定制的。用于在一定情况下取代HashMap而达到节省内存的目的。

## 实现原理

1. HashMap实现原理:

![](https://user-gold-cdn.xitu.io/2017/10/22/1390e3ec5b27f8d6997288949cf78cf4?imageView2/0/w/1280/h/960/ignore-error/1)



利用hash算法，插入和查找等操作都很快，且一般情况下，每一个数组值后面不会存在很长的链表（因为出现hash冲突毕竟占比较小的比例），所以不考虑空间利用率的话，HashMap的效率非常高。



2. ArrayMap实现原理

![](https://user-gold-cdn.xitu.io/2017/10/22/4db9e57f253bc8a7b4a8d43158424843?imageView2/0/w/1280/h/960/ignore-error/1)



ArrayMap利用两个数组，mHashes用来保存每一个key的hash值，mArrray大小为mHashes的2倍，依次保存key和value。时间效率上看，插入和查找的时候因为都用的二分法，查找的时候应该是没有hash查找快，插入的时候呢，如果顺序插入的话效率肯定高，但如果是随机插入，肯定会涉及到大量的数组搬移，数据量大的话其实不如HashMap的效率高。



3. SparseArray实现原理

![](https://user-gold-cdn.xitu.io/2017/10/22/0634559b1dd4861b519761c8ed8fd5f4?imageView2/0/w/1280/h/960/ignore-error/1)

sparseArray相对来说就简单的多了，但是不要以为它可以取代前两种，sparseArray只能在key为int的时候才能使用，**注意是int而不是Integer**，这也是sparseArray效率提升的一个点，**去掉了装箱的操作!**。



## 测试

1. 正序插入测试

![](https://user-gold-cdn.xitu.io/2017/10/22/64ba154f63a7e0295493a9764d2203fd?imageView2/0/w/1280/h/960/ignore-error/1)

分析：从结果上来看，数据量小的时候，差异并不大（当然了，数据量小，时间基准小，内容太多,就不贴数据表了，确实差异不大），当数据量大于5000左右，SparseArray，最快，HashMap最慢，乍一看，好像SparseArray是最快的，但是要注意，这是顺序插入的。也就是SparseArray和Arraymap最理想的情况。



2. 倒序插入测试

![](https://user-gold-cdn.xitu.io/2017/10/22/713b08190d67abd8a1b7af28cc5de5c2?imageView2/0/w/1280/h/960/ignore-error/1)



分析：从结果上来看，果然，HashMap远超Arraymap和SparseArray，也前面分析一致。
当然了，数据量小的时候，例如1000以下，这点时间差异也是可以忽略的。



3. 内存占用对比

![](https://user-gold-cdn.xitu.io/2017/10/22/fdda8641bf974bd6e3c3ffd545a05b19?imageView2/0/w/1280/h/960/ignore-error/1)

分析：可见，SparseArray在内存占用方面的确要优于HashMap和ArrayMap不少，通过数据观察，大致节省30%左右，而ArrayMap的表现正如前面说的，优化作用有限，几乎和HashMap相同。



4. 查询性能对比

![](https://user-gold-cdn.xitu.io/2017/10/22/59724090e515c61615ea93bb02e51215?imageView2/0/w/1280/h/960/ignore-error/1)

分析：直接对比发现SparseArray最快，HashMap最慢（但是SparseArray并未有装箱的过程），如果SparseArray加上装箱的过程再进行对比会发现HashMap最快

![](https://user-gold-cdn.xitu.io/2017/10/22/67698a1cb15a855e36ac876a2c3d53ee?imageView2/0/w/1280/h/960/ignore-error/1)



## 总结

1. 在数据量小的时候一般认为1000以下，当你的key为int的时候，使用SparseArray确实是一个很不错的选择，内存大概能节省30%，相比用HashMap，因为它key值不需要装箱，所以时间性能平均来看也优于HashMap,建议使用！
2. ArrayMap相对于SparseArray，特点就是key值类型不受限，任何情况下都可以取代HashMap,但是通过研究和测试发现，ArrayMap的内存节省并不明显，也就在10%左右，但是时间性能确是最差的，当然了，1000以内的数据量也无所谓了，加上它只有在API>=19才可以使用，个人建议没必要使用！还不如用HashMap放心。🤪



参考来源——[https://juejin.im/entry/59ec06646fb9a0451049a1b4]

