package com.fitmgr.resourcecenter.service.network.firewall;

import com.fitmgr.resourcecenter.common.utils.Ipv4Util;
import com.fitmgr.resourcecenter.db.dto.SubnetDTO;
import com.fitmgr.resourcecenter.db.entity.FirewallRuleServices;
import com.fitmgr.resourcecenter.service.network.subnet.SubnetManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class FirewallRuleServiceManager {
    @Autowired
    private SubnetManager subnetManager;

    public FirewallRuleServices createFirewallRuleServices(){

        return new FirewallRuleServices();
    }

    public Map<String, String> verifyFirewallRuleServicesParams(FirewallRuleServiceVerifyBody firewallRuleServiceVerifyBody){
        Map<String, String> responce = new HashMap<>();
        List<String> srcIps = firewallRuleServiceVerifyBody.getSourceIpAddresses();
        List<String> desIps = firewallRuleServiceVerifyBody.getDestIpAddresses();

        Boolean srcIpsFlag = verify(srcIps);
        Boolean desIpsFlag = verify(desIps);

        if(!srcIpsFlag & !desIpsFlag){
            responce.put("result", "unavailable");
            return responce;
        }else {
            responce.put("result", "available");
            return responce;
        }

    }

    public Boolean verify(List<String> rangesOrCidrs){
        Boolean allInSubnetFlag = true;
        for(String item: rangesOrCidrs){
            if(Ipv4Util.isCidr(item)){
                List<SubnetDTO> subnetCidrDTOSResult = subnetManager.getSubnetsByCidrInCidr(item, null,null,null,null, null);
                if (subnetCidrDTOSResult == null){
                    allInSubnetFlag = false;
                }
            }else if (Ipv4Util.isIpRange(item)){
                List<SubnetDTO> subnetRangeDTOSResult = subnetManager.getSubnetsByIpRangeInCidr(item, null,null,null,null, null);
                if (subnetRangeDTOSResult == null){
                    allInSubnetFlag = false;
                }
            }
        }
        return allInSubnetFlag;
    }
}
