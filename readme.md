# CRM_readme

还在更新ing...

使用的技术：maven git

前端原型：搭建的html页面

前端：Bootstrap（UI）+ jQuery

后端：SpringMVC + Spring + Mybatis 框架

工具包：UUIDUtil、ServiceFactory、DataTimeUtil等

服务器：Tomcat

测试：juit

插件：自动补全 统计图表EChars Mybatis逆向工程的插件等

系统介绍：
    客户关系系统CRM，用于处理和存储市场活动、线索、客户信息、交易信息等企业业务相关的数据

### 一、物理模型

物理模型共有：

1. 数据字典
2. 用户
3. 市场活动
4. 线索\_客户\_联系人\_交易

创建模型：

使用PowerDesigner创建物理模型，生成 .pdm 文件

### 二、搭建项目

1. 设置字体

2. 设置字符集 utf-8

3. 设置basePath变量 及 base标签

   ```jsp
   <%
   	String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +  request.getContextPath() + "/";
   %>
   <base href = "<%=path%>">
   ```

4. 创建maven：使用settings引入本地仓库
    1. 搭建webapp模板
    
5. 搭建项目结构
    
    main/java  main/resources src/test
    
6. 导入pom依赖
    
       <dependency>
             <groupId>junit</groupId>
             <artifactId>junit</artifactId>
             <version>4.12</version>
             <scope>test</scope>
           </dependency>
    
       ```xml
       <dependency>
         <groupId>javax.servlet</groupId>
         <artifactId>javax.servlet-api</artifactId>
         <version>4.0.1</version>
         <scope>provided</scope>
       </dependency>
       
       <dependency>
         <groupId>javax.servlet.jsp</groupId>
         <artifactId>jsp-api</artifactId>
         <version>2.1.3-b06</version>
         <scope>provided</scope>
       </dependency>
       
       <dependency>
         <groupId>org.mybatis</groupId>
         <artifactId>mybatis</artifactId>
         <version>3.4.5</version>
       </dependency>
       
       <dependency>
         <groupId>javax.servlet</groupId>
         <artifactId>jstl</artifactId>
         <version>1.2</version>
       </dependency>
       
       <dependency>
         <groupId>com.fasterxml.jackson.core</groupId>
         <artifactId>jackson-core</artifactId>
         <version>2.0.1</version>
       </dependency>
       
       <dependency>
         <groupId>com.fasterxml.jackson.core</groupId>
         <artifactId>jackson-databind</artifactId>
         <version>2.0.0</version>
       </dependency>
       
       <dependency>
             <groupId>mysql</groupId>
             <artifactId>mysql-connector-java</artifactId>
             <version>8.0.26</version>
           </dependency>
       </dependency>
       
       <dependency>
         <groupId>log4j</groupId>
         <artifactId>log4j</artifactId>
         <version>1.2.17</version>
       </dependency>
       ```
    
       正常得设置 .properties 和 .xml的扫描声明，我直接写到resources下 就不用加声明了
    
       我自己的mysql是8的所以这个 mysql 连接依赖得改版本
    
    > 这里学习的项目是ssm，Mybatis主配置文件是单独出来的，这里我改为spring集成，mybatis的配置文件只是用来配置日志的，其中的DataSource和Mapper声明代理dao都写到spring中
    
    **创建数据库**
    
    数据库名：crm_01
    
    字符集：utf-8
    
    **前端**
    
    将前端原型拷贝到webapp下
    
    **服务器**
    
    使用Tomcat服务器
    
    设置热部署 并且 修改Tomcat名称
    
    URL：http://localhost:8080/CRM_01/
    
**CRM模块划分**

* 系统设置模块（settings）

  * 用户模块：登录

    设计到数据字典模块信息的查询

* 工作台（workbench）

  * 市场活动模块：activity

* 工具包utils

  * UUID：生成32位随机串
  * DateTime：日期
  * MD5：加密算法
  * PrintJson：解析json串

* 搭建用户相关的domain、dao、service、controller

* 对于dao 层命名的说明：

  
    

    

### 三、登录模块
关乎登录
验证账号和密码
select count(*) from tbl_user where LoginAct=? and LoginPwd = ?
* 查询记录为0 表示没查到
* 查询记录为1 表示符合
* 查询记录大于1 有垃圾数据

执行sql语句 返回 User对象

* 如果User对象为空：账号密码错误
* 如果不为空：只能说明账号密码正确 需要继续向下验证字段信息
从User中get expireTime 验证失效时间 lockState 锁定状态 allowips 验证浏览器端的ip地址是否有效

验证失效时间

打印失效时间字段expireTime，和当前时间比较

代码：
````
// 失效时间
@Test
public void testExpireDate(){
    Date date = new Date();
    System.out.println(date);
    // Sat Nov 13 22:37:43 CST 2021
    
    // 将当前时间按照指定格式进行输出
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String dateFormat = sdf.format(date);
    System.out.println(dateFormat);
    // 2021-11-13 22:37:43
}
````
验证失效时间借助字符串方法comepareTo

该方法返回值：

* 大于0：调用方法的字符串数值大于方法内的字符串数值
* 小于0：调用方法的字符串数值小于方法内的字符串数值
* 等于0：字符串内数值相等

代码：

```java
// 获取当前系统时间 （使用工具包）
String currentTime = DateTimeUtil.getSysTime();

String expireTime = "2012-11-13 22:41:29";
int i = expireTime.compareTo(currentTime);
// i > 0 -> expireTime > currentTime 未失效
// i < 0 -> expireTime < expireTime 失效
System.out.println(i);
```

验证是否锁定

```java
String lockState = "0";
// 字符串写前面 不会空指针
if ("0".equals(lockState)){
    System.out.println("账号已锁定");
}else {
    System.out.println("pass");
}
```

验证ip地址

```java
String ip = "192.168.1.10";
String allIps = "192.168.1.10,192.168.5.21";
if (allIps.contains(ip)){
    System.out.println("有效的ip");
}else {
    System.out.println("无效的ip");
}
```

验证密码MD5加密

```java
String pwd = "123";
pwd = MD5Util.getMD5(pwd);
System.out.println(pwd);
// 202cb962ac59075b964b07152d234b70
```

### UML

绘制时序图

工具：Rational Rose



**前端改造**：

1. 将登录Login.html改为Jsp文件

   并且加上base标签 防止相对路径出错

2. 每次切动服务器进入登录页面时自动将焦点放到用户名输入框

3. 并且每次登录如果出现异常都要给用户一个提示信息显示到登录界面中

   * 这里使用ajax传递用户名密码
   * 统一异常处理 自定义的异常（抛出异常时传递异常信息）

4. 这里本来想使用SpringMVC自带的拦截器，但是不好使，百度之后改了一些也不行

   就放弃了，用的原生的过滤器Filter

### 四、市场活动

1. 时长活动表的设计

   建表：

   ​	tbl_activity 市场活动表

   ​	tbl_activity_remark 市场活动备注表

   ​	一对多的关系

2. 市场活动的创建和修改都是以模态窗口的形式展现

出现的问题：

​	当我们重启服务器后，如果我们刷新页面会重新进入登录界面，但是如果我们点击市场活动或者其他导航栏按钮，就会出现只有工作区变成登录页面，很丑...


解决方案：

在登录页加入代码（js中）

```javascript
if (window.top != window ){
   window.location.top = window.location;
}
```



**创建工作台的组件**

项目结构：crm / workbench / 

这里的dao、domain、mapper.xml我直接用Mybatis逆向工程生成了（tbl_activity tbl_activity_remark）

主配置文件记得把注解扫描添加一下

**展现市场活动的模态窗口**

这里data-toggle="modal" 表示触发事件 打开模态窗口
data-target="#createActivityModal" 表示具体打开哪个模态窗口 根据#id
由于这里占用了两个属性，如果要添加操作在事件上加不了 被写死了
所以改为使用jQuery完成

> 这里要为按钮设置id
>
> id的设置需要一定约束，每个公司 项目都不一样
>
> 这里设置：
>
> add / create 表示打开模态窗口 跳转到添加页
>
> save 执行添加操作
>
> edit 跳转到修改页 或者打开修改操作的模态窗口
>
> update 执行修改操作
>
> get 执行查询操作 find / select / query / .. 也可以
>
> 特殊操作： login 等

添加模态窗口

​	需要操作的模态窗口的jquery对象调用modal()方法 传入参数

* show 打开模态窗口
* hide 隐藏模态窗口

### 五、核心业务搭建

1. 线索模块

   * tbl_clue 线索表
   * tbl_clue_remark 线索备注表
   * tbl_clue_activity_relation 线索和市场活动关联关系表

2. 客户模块

   * tbl_customer 客户表
   * tbl_customer_remark 客户备注表

3. 联系人相关表

   * tbl_contacts 联系人表
   * tbl_contacts_remark 联系人备注表
   * tbl_contacts_activity_relation 联系人和市场活动关联关系表

4. 交易模块

   * tbl_tran 交易表
   * tbl_tran_remark 交易备注表
   * tbl_tran_history 交易历史表

5. 数据字典相关表

   * tbl_dic_type 字典类型表
   * tbl_dic_value 字典值表

6. 将线索 客户 联系人 交易模块的html修改为jsp 解决404

7. 搭建线索、客户、联系人、交易 domain dao service controller

8. 解析crm中的多对多关系

   实际项目开发中，基本上半数以上的需求，都是一对多，或者多对一的关系。

   以上关系我们存在一种很特殊的关系，一对一的关系 

   不论是一对多 还是 多对一 还是一对一，我们都是在其中一张表建立外键（多）来维护表与表之间的关系

   多对多关系：人和职业，一个人可以有多份职业，一个职业可以由多个人去做

   

9. cache（缓存机制）解决数据字典存储问题

   关键代码

   缓存（cache）：内存中的数据

   我们马上要做的是一种服务器缓存的机制，就相当于将数据保存到服务器的内存中

   如果服务器处于开启状态，我们就一直能够从该缓存中取得数据

   application（全局作用域，上下文作用域）

   在服务器启动状态，将数据保存到服务器缓存中，服务器启动状态，数据始终存在

   将数据保存到服务器缓存中的手段：application.setAttribute()

   从服务器缓存中取出数据：application.getAttribute()

10. 数据字典：

   指的是在应用程序中，做表单元素选择内容用的相关数据（下拉框 单选框 复选框）

   数据字典被普遍应用在下拉框中

   对于数据字典提供了两种表

   * tbl_dic_type 字典类型表
   * tbl_dic_value 字典值表

   一种类型对应多个值，一个值，只能从属于一种类型 

11. 将服务器缓存和数据字典结合起来

   如何让application在服务器启动阶段，就将数据字典保存起来：监听器

   > 监听器：监听域对象和域对象属性的变化

   现在的需求：监听上下文域对象的创建



### 六、数据字典

​	当我们使用一些选项类的数据，例如 性别选项：男 女，这里男可以为男性、男生、男人、man，这里如果每次都要修改这些内容十分繁琐并且浪费时间，所以我们可以将这部分的修改权限放给用户，让用户自定义其中内容

​	如果每次加载这些内容都要在数据库中查询一次，十分占用内容和cpu，这里可以进行缓存，将数据字典数据保存到application域中（上下文域），随着服务器开启创建，随着服务器关闭销毁（监听器）

​	对于数据字典的查询，由于一次查完数据量很大，每次使用都是其中一部分几条，所以查询数据要分门别类

​	根据typecode进行查询：称呼、线索状态、回访优先级、阶段等

实现步骤：

1. 创建一个监听器类 实现ServletContextListener接口
2. 实现其中 init destroy方法
3. 通过service实例 创建方法获取分类后的List（保存在map中）

这里出现了一个问题：

> 在监听器中（@WebListener）中使用spring自动装配@Resource service 其实例无法注入，由于监听器在Tomcat容器中第一个创建，所以无法自动注入（顺序有问题），这里可以手动获取 new ClasspathApplicationContext 或者 WebApplicationContextUtils.getWebApplicationContext.getBean都可以



关于点击查询按钮后两次查询问题：

> 这里我每点击一次按钮，都会自动刷新一次页面，将上一次条件查询的内容覆盖，变为全部查询，这里卡了好久，最后得出结论，查询按钮type为submit会默认提交，在按钮点击事件结束后会再次提交



### 七、线索与市场活动关联

这里线索表与市场活动表是多对多的关系，需要建立一张第三方表存储两张表的外键

即：

* tbl_activity
* tbl_clue
* tbl_clue_activity_relation

注意：

在写线索详情页中的添加关联时，选中多个市场活动记录的id，ajax请求中由于发送的是数组，所以不需要加引号

> 这里在进行获取id时由于使用jQuery获取的是jQuery对象
>
> 我使用forEach 获取其中的dom对象，由于dom对象不能使用val()方法，我再使用$(domObj)将其转化为jquery对象使用 val() 方法获取value属性存储的activityid

SpringMVC在接收时使用注解@RequestParam（value=“xxx[]”）形式接收



