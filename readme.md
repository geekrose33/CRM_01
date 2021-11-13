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

    

### 三、登录模块