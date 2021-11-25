package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.MD5Util;
import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.ActivityMapper;
import com.geekrose.crm.workbench.dao.ClueActRelationMapper;
import com.geekrose.crm.workbench.dao.ClueMapper;
import com.geekrose.crm.workbench.dao.ClueRemarkMapper;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.Clue;
import com.geekrose.crm.workbench.domain.ClueActRelation;
import com.geekrose.crm.workbench.domain.ClueRemark;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:16
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {
    @Resource
    private UserMapper userDao;

    @Resource
    private ClueMapper clueDao;

    @Resource
    private ClueRemarkMapper remarkDao;

    @Resource
    private ClueActRelationMapper clueActDao;

    @Resource
    private ActivityMapper actDao;

    public List<User> getUsers() {
        List<User> users = userDao.selectUserList();
        return users;
    }

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
        List<ClueRemark> list = remarkDao.getRemarksByClueId(id);
        return list;
    }

    public boolean addClueRemark(ClueRemark remark) {
        boolean flag = false;
        remark.setCreatetime(DateTimeUtil.getSysTime());
        remark.setId(MD5Util.getMD5(UUIDUtil.getUUID()));
        remark.setEditflag("0");
        int i = remarkDao.insert(remark);
        if (i == 1){
            flag = true;
        }
        return flag;
    }

    public boolean removeRemark(String id) {
        int i = remarkDao.deleteByPrimaryKey(id);
        if (i == 1){
            return true;
        }
        return false;
    }

    public boolean updateClueRemark(String id, String notecontent) {
        ClueRemark remark = new ClueRemark();
        remark.setId(id);
        remark.setNotecontent(notecontent);
        int i = remarkDao.updateByPrimaryKeySelective(remark);
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

    public boolean bondActClue(String clueId, String[] actIds) {

        int i = 0;
        for (String actId : actIds) {

            ClueActRelation relation = new ClueActRelation();
            relation.setId(MD5Util.getMD5(UUIDUtil.getUUID()));
            relation.setClueid(clueId);
            relation.setActivityid(actId);
            i += clueActDao.insert(relation);
        }
        if (i == actIds.length){
            return true;
        }

        return false;
    }
}
