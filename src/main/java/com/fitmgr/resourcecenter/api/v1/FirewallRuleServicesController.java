package com.fitmgr.resourcecenter.api.v1;


import com.fitmgr.resourcecenter.common.utils.RB;
import com.fitmgr.resourcecenter.db.entity.FirewallRuleServices;
import com.fitmgr.resourcecenter.service.network.firewall.FirewallRuleServiceManager;
import com.fitmgr.resourcecenter.service.network.firewall.FirewallRuleServiceVerifyBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Map;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author wuyaming
 * @since 2019-12-06
 */
@RestController
@RequestMapping("/firewall-rule-services")
public class FirewallRuleServicesController {
    @Autowired
    private FirewallRuleServiceManager firewallRuleServiceManager;

    @PostMapping(value = {""})
    public RB createFirewallRuleServices(@RequestHeader(value = "Tenant-Id", required = false) String tenant_id,
                                         @RequestHeader(value = "Project-Id", required = false) String project_id,
                                         @RequestHeader(value = "User-Id", required = false) String user_id,
                                         @RequestHeader(value = "Scope", required = false) String scope,
                                         @Valid @RequestBody FirewallRuleServices firewallRuleServicesRequest) {
        FirewallRuleServices response = firewallRuleServiceManager.createFirewallRuleServices(firewallRuleServicesRequest);
        return new RB <> (response);
    }

    @PutMapping(value = {"/params_verify"})
    public RB verifyFirewallRuleServicesParams(FirewallRuleServiceVerifyBody firewallRuleServiceVerifyBody){
        Map<String, String> response = firewallRuleServiceManager.verifyFirewallRuleServicesParams(firewallRuleServiceVerifyBody);
        return null;
    }

}
