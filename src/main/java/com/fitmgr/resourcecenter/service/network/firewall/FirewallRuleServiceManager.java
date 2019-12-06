package com.fitmgr.resourcecenter.service.network.firewall;

import com.fitmgr.resourcecenter.db.entity.FirewallRuleServices;
import org.springframework.stereotype.Component;

@Component
public class FirewallRuleServiceManager {
    public FirewallRuleServices createFirewallRuleServices(){

        return new FirewallRuleServices();
    }

    public Boolean verifyFirewallRuleServicesParams(){

        return true;
    }
}
