drop table if exists tbl_user;

/*==============================================================*/
/* Table: tbl_user                                              */
/*==============================================================*/
create table tbl_user
(
   id                   char(32) not null comment 'uuid
            ',
   loginAct             varchar(255),
   name                 varchar(255),
   loginPwd             varchar(255) comment '���벻�ܲ������Ĵ洢���������ģ�MD5����֮�������',
   email                varchar(255),
   expireTime           char(19) comment 'ʧЧʱ��Ϊ�յ�ʱ���ʾ����ʧЧ��ʧЧʱ��Ϊ2018-10-10 10:10:10�����ʾ�ڸ�ʱ��֮ǰ���˻����á�',
   lockState            char(1) comment '����״̬Ϊ��ʱ��ʾ���ã�Ϊ0ʱ��ʾ������Ϊ1ʱ��ʾ���á�',
   deptno               char(4),
   allowIps             varchar(255) comment '������ʵ�IPΪ��ʱ��ʾIP��ַ�������ޣ�������ʵ�IP������һ����Ҳ�����Ƕ���������IP��ַ��ʱ�򣬲��ð�Ƕ��ŷָ�������IP��192.168.100.2����ʾ���û�ֻ����IP��ַΪ192.168.100.2�Ļ�����ʹ�á�',
   createTime           char(19),
   createBy             varchar(255),
   editTime             char(19),
   editBy               varchar(255),
   primary key (id)
);
