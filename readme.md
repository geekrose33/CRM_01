# CRM_readme

搭建maven项目

前端原型：搭建的html

前端：Bootstrap（UI）+ jQuery

后端：SpringMVC + Spring + Mybatis 框架

工具包：UUIDUtil、ServiceFactory、DataTimeUtil等

服务器：Tomcat

插件：自动补全 统计图表EChars



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
    
    > 这里学习的项目是ssm，Mybatis主配置文件是单独出来的，这里我改为spring集成，直接写到spring配置文件中，只保留一个applicationContext.xml文件，配置文件太多看着闹心
    
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