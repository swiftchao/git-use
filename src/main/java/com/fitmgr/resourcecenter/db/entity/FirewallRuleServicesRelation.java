package com.fitmgr.resourcecenter.db.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author wuyaming
 * @since 2019-12-06
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class FirewallRuleServicesRelation implements Serializable {

    private static final long serialVersionUID = 1L;

    private String firewallRuleServiceUuid;

    private String firewallRuleUuids;

    private String firewallIpGroupUuids;

    private String firewallServiceGroupUuids;


}
