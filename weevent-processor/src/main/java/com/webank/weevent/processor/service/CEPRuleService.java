package com.webank.weevent.processor.service;

import java.util.List;

import com.webank.weevent.processor.model.CEPRule;
import com.webank.weevent.processor.model.CEPRuleExample;
import com.webank.weevent.processor.utils.RetCode;

public interface CEPRuleService {
    CEPRule selectByPrimaryKey(String id);

    List<CEPRule> selectByRuleName(String ruleName);

    String insert(CEPRule record);

    List<CEPRule> getCEPRuleList(String ruleName);

    List<CEPRule> getCEPRuleListByPage(int currPage, int pageSize);

    RetCode updateByPrimaryKey(CEPRule record);

    RetCode setCEPRule(CEPRule rule);

    RetCode setCEPRule(String id, int type);

    RetCode updateByPrimaryKeySelective(CEPRule record);

    int getCountByCondition(CEPRuleExample cEPRuleExample);


    List<CEPRule> getRulesByBrokerId(String brokerId);

    List<CEPRule> getRulesByUserId( String userId);

    List<CEPRule>  getRulesByUserIdAndBroker( String userId,String brokerId);
}
