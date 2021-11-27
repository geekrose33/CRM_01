package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.MD5Util;
import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.*;
import com.geekrose.crm.workbench.domain.*;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:16
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {
    // 用户表
    @Resource
    private UserMapper userDao;
    // 线索表
    @Resource
    private ClueMapper clueDao;

    @Resource
    private ClueRemarkMapper clueRemDao;

    @Resource
    private ClueActRelationMapper clueActDao;
    // 市场活动表
    @Resource
    private ActivityMapper actDao;

    // 客户表
    @Resource
    private CustomerMapper cusDao;

    @Resource
    private CustomerRemarkMapper cusRemDao;

    // 联系人表
    @Resource
    private ContactsMapper conDao;

    @Resource
    private ConRemarkMapper conRemDao;

    @Resource
    private ConActRelationMapper conActRelDao;


    // 交易表
    @Resource
    private TransactionMapper tranDao;

    @Resource
    private TranRemarkMapper tranRemDao;

    @Resource
    private TranHistoryMapper tranHisDao;



    public List<User> getUsers() {
        List<User> users = userDao.selectUserList();
        return users;
    }

    @Transactional
    public boolean saveClue(Clue clue) {
        boolean flag = false;
        // 设置id
        clue.setId(UUIDUtil.getUUID());
        // 设置创建时间
        clue.setCreatetime(DateTimeUtil.getSysTime());
        int i = clueDao.insert(clue);
        if (i == 1){
            flag = true;
        }

        return flag;
    }

    public List<Clue> getClues(String pageNo,String pageSize,Clue clue) {
        Integer ipageNo = Integer.valueOf(pageNo);
        Integer ipageSize = Integer.valueOf(pageSize);

        ipageNo = (ipageNo - 1)*ipageSize;

        List<Clue> list = clueDao.selectClues(ipageNo,ipageSize,clue);
        return list;
    }

    public int getTotalCount() {
        int num = clueDao.getTotalCount();
        return num;
    }

    public Clue getEditInfoById(String id) {
        Clue clue = clueDao.getEditInfoById(id);

        return clue;
    }

    @Transactional
    public boolean updateClue(Clue clue) {
        clue.setEdittime(DateTimeUtil.getSysTime());
        // 将owner的String换成id
        String uid = userDao.getIdByName(clue.getOwner());

        clue.setOwner(uid);

        int i = clueDao.updateByPrimaryKeySelective(clue);
        if (i == 1){
            return true;
        }
        return false;
    }

    @Transactional
    public boolean deleteClue(String id) {
        boolean flag = false;
        int i = clueDao.deleteByPrimaryKey(id);

        if (i==1){
            flag = true;
        }

        return flag;
    }

    public Clue getClueById(String id) {

        Clue clue = clueDao.selectByPrimaryKey(id);

        return clue;
    }

    public List<ClueRemark> showClueRemark(String id) {
        List<ClueRemark> list = clueRemDao.getRemarksByClueId(id);
        return list;
    }

    @Transactional
    public boolean addClueRemark(ClueRemark remark) {
        boolean flag = false;
        remark.setCreatetime(DateTimeUtil.getSysTime());
        remark.setId(UUIDUtil.getUUID());
        remark.setEditflag("0");
        int i = clueRemDao.insert(remark);
        if (i == 1){
            flag = true;
        }
        return flag;
    }

    @Transactional
    public boolean removeRemark(String id) {
        int i = clueRemDao.deleteByPrimaryKey(id);
        if (i == 1){
            return true;
        }
        return false;
    }


    @Transactional
    public boolean updateClueRemark(String id, String notecontent) {
        ClueRemark remark = new ClueRemark();
        remark.setId(id);
        remark.setNotecontent(notecontent);
        int i = clueRemDao.updateByPrimaryKeySelective(remark);
        if (i == 1){
            return true;
        }
        return false;
    }

    public List<Activity> getActivityListByClueId(String id) {
        // 这里的id 是clue id
//        String actIds[] = clueActDao.selectActIdsByClueId(id);
//        List<Activity> acts = actDao.selectActsByIds(actIds);
        List<Activity> acts = actDao.getActsByClueId(id);
        return acts;
    }


    @Transactional
    public boolean deleteRelation(String id) {

        int i = clueActDao.deleteByPrimaryKey(id);
        if (i == 1){
            return true;
        }

        return false;
    }


    public List<Activity> getActListForNameNotByClueId(String name, String clueId) {

        List<Activity> list = actDao.getActsForNameNotByClueId(name,clueId);
        return list;
    }

    @Transactional
    public boolean bondActClue(String clueId, String[] actIds) {

        int i = 0;
        for (String actId : actIds) {

            ClueActRelation relation = new ClueActRelation();
            relation.setId(UUIDUtil.getUUID());
            relation.setClueid(clueId);
            relation.setActivityid(actId);
            i += clueActDao.insert(relation);
        }
        if (i == actIds.length){
            return true;
        }

        return false;
    }

    public List<Activity> getActListByName(String name) {
        List<Activity> list = actDao.selectActivitiesByName(name);
        return list;
    }

    /*
        线索转换设计多张表：
            1. 线索表
            2. 客户表
            3. 联系人表
            4. 交易表
    */


    @Transactional
    public boolean convertClue(String clueid, Transaction tran, String createby) {

        String createtime = DateTimeUtil.getSysTime();

        boolean flag = true;
        // 第一步 根据clueid获取Clue的详细信息
        Clue clue = clueDao.getClueById(clueid);

        // 第二步 通过线索对象提供客户信息 当客户不存在时，新建客户
        Customer cus = cusDao.getCustomerByName(clue.getCompany());
        if (cus == null){
            // 不存在
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setAddress(clue.getAddress());
            cus.setCreateby(createby);
            cus.setCreatetime(createtime);
            cus.setOwner(clue.getOwner());
            cus.setPhone(clue.getPhone());
            cus.setWebsite(clue.getWebsite());
            cus.setDescription(clue.getDescription());
            cus.setName(clue.getCompany());
            cus.setNextcontacttime(clue.getNextcontacttime());
            cus.setContactsummary(clue.getContactsummary());

            int cusNum = cusDao.insert(cus);
            if (cusNum != 1){
                flag = false;
            }
        }
        /*
            经过第二步后 客户的信息已经具备了
            在使用客户id 直接cus.getId即可
        */
        // 第三步 通过线索对象提供联系人信息
        Contacts con = new Contacts();
        con.setAddress(clue.getAddress());
        con.setAppellation(clue.getAppellation());
        con.setContactsummary(clue.getContactsummary());
        con.setCreateby(createby);
        con.setCreatetime(createtime);
        con.setId(UUIDUtil.getUUID());
        con.setDescription(clue.getDescription());
        con.setFullname(clue.getFullname());
        con.setJob(clue.getJob());
        con.setMphone(clue.getMphone());
        con.setNextcontacttime(clue.getNextcontacttime());
        con.setCustomerid(cus.getId());
        con.setOwner(clue.getOwner());
        con.setEmail(clue.getEmail());
        con.setSource(clue.getSource());
        int conNum = conDao.insert(con);

        if (conNum != 1){
            flag = false;
        }

        /*
            经过第三步处理 可以直接使用con.getId
        */
        // 将线索备注表转换为客户备注和联系人备注
        List<ClueRemark> remarks = clueRemDao.getRemarksByClueId(clueid);

        for (ClueRemark remark : remarks) {
            // 需要的信息就是备注信息
            String notecontent = remark.getNotecontent();

            // 创建客户备注 添加备注
            CustomerRemark cusRemark = new CustomerRemark();
            cusRemark.setCreateby(createby);
            cusRemark.setCreatetime(createtime);
            cusRemark.setCustomerid(cus.getId());
            cusRemark.setEditflag("0");
            cusRemark.setNotecontent(notecontent);
            cusRemark.setId(UUIDUtil.getUUID());

            int cusRemNum = cusRemDao.insert(cusRemark);
            if (cusRemNum != 1){
                flag = false;
            }

            // 创建联系人备注 添加备注
            ConRemark conRemark = new ConRemark();
            conRemark.setCreateby(createby);
            conRemark.setCreatetime(createtime);
            conRemark.setContactsid(con.getId());
            conRemark.setEditflag("0");
            conRemark.setId(UUIDUtil.getUUID());
            conRemark.setNotecontent(notecontent);

            int conRemNum = conRemDao.insert(conRemark);
            if (conRemNum != 1){
                flag = false;
            }


        }
        
        // 将线索关联市场活动表 转为联系人关联市场活动表
        List<ClueActRelation> clueActRelations = clueActDao.getListByClueId(clueid);
        for (ClueActRelation relation : clueActRelations) {

            String activityid = relation.getActivityid();
            // 创建联系人关联市场活动表
            ConActRelation conActRelation = new ConActRelation();
            conActRelation.setId(UUIDUtil.getUUID());
            conActRelation.setActivityid(activityid);
            conActRelation.setContactsid(con.getId());

            int conRelNum = conActRelDao.insert(conActRelation);
            if (conRelNum != 1){
                flag = false;
            }

        }


        // 通过线索对象添加交易信息
        if (tran!=null){

            // 封装好的信息 id money name expectedDate stage activityId
            tran.setId(UUIDUtil.getUUID());
            tran.setCreatetime(createtime);
            tran.setCreateby(createby);
            tran.setCustomerid(cus.getId());
            tran.setContactsummary(clue.getContactsummary());
            tran.setDescription(clue.getDescription());
            tran.setContactsid(con.getId());
            tran.setNextcontacttime(clue.getNextcontacttime());
            tran.setOwner(clue.getOwner());
            tran.setSource(clue.getSource());
            // 这里判断业务类型根据业务名称 相同的为已有业务 不同的为新业务
            int isNum = tranDao.selectTranByName(tran.getName());
            if (isNum == 0){
                tran.setType("新业务");
            }else {
                tran.setType("已有业务");
            }

            int tranNum = tranDao.insert(tran);
            if (tranNum!=1){
                flag = false;
            }


            // 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHis = new TranHistory();
            tranHis.setCreateby(createby);
            tranHis.setCreatetime(createtime);
            tranHis.setExpecteddate(tran.getExpecteddate());
            tranHis.setId(UUIDUtil.getUUID());
            tranHis.setMoney(tran.getMoney());
            tranHis.setStage(tran.getStage());
            tranHis.setTranid(tran.getId());
            int tranHisNum = tranHisDao.insert(tranHis);
            if (tranHisNum != 1){
                flag = false;
            }
        }

        // 删除线索备注
        for (ClueRemark remark : remarks) {

            int clueRemDelNum = clueRemDao.deleteByPrimaryKey(remark.getId());
            if (clueRemDelNum != 1){
                flag = false;
            }

        }

        // 删除市场活动和线索关联关系
        for (ClueActRelation clueActRelation : clueActRelations) {

            int clueActDelNum = clueActDao.deleteByPrimaryKey(clueActRelation.getId());
            if (clueActDelNum != 1){
                flag = false;
            }

        }


        // 删除线索
        int clueDelNum = clueDao.deleteByPrimaryKey(clueid);
        if (clueDelNum != 1){
            flag = false;
        }

        return flag;

    }
}
