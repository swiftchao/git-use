package com.fitmgr.resourcecenter.db.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;

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
public class FirewallRuleServices implements Serializable {

    private static final long serialVersionUID = 1L;

    private String uuid;

    private String name;

    private String description;

    @NotBlank
    private String srcIpAddresses;

    @NotBlank
    private String dstIpAddresses;

    @NotBlank
    private String srcPorts;

    @NotBlank
    private String dstPorts;

    private String protocol;

    private Integer action;

    private String status;

    private String ruleInstances;

    private String tenantId;

    private String projectId;

    private String userId;

    private String createdAt;

    private String updatedAt;


}
