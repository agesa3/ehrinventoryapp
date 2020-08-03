package org.openmrs.module.ehrinventoryapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugIndent;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.ehrinventory.InventoryService;
import org.openmrs.module.ehrinventory.model.InventoryStoreDrugIndentDetail;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;


public class DetailDrugIndentPageController {
    public void get(
            @RequestParam(value = "indentId", required = false) Integer indentId,
            PageModel model) {
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        InventoryStoreDrugIndent indent = inventoryService
                .getStoreDrugIndentById(indentId);
        List<InventoryStoreDrugIndentDetail> listIndentDetail = inventoryService
                .listStoreDrugIndentDetail(indentId);
        model.addAttribute("listIndentDetail", listIndentDetail);
        List<InventoryStoreDrugTransactionDetail> listTransactionDetail= new ArrayList<InventoryStoreDrugTransactionDetail>();
        if (indent != null && indent.getTransaction() != null) {
             listTransactionDetail = inventoryService
                    .listTransactionDetail(indent.getTransaction().getId());
        }
        model.addAttribute("listTransactionDetail", listTransactionDetail);
        model.addAttribute("store",
                !CollectionUtils.isEmpty(listIndentDetail) ? listIndentDetail
                        .get(0).getIndent().getStore() : null);
        model.addAttribute("date",
                !CollectionUtils.isEmpty(listIndentDetail) ? listIndentDetail
                        .get(0).getIndent().getCreatedOn() : null);
        model.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));

    }

}
