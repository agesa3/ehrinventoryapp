<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Process Indent "])
%>
<script>
    jq(function () {
        var storeIndent = ${listDrugNeedProcess};
        var pStoreIndent = storeIndent.listDrugNeedProcess;

        function IndentListViewModel() {
            var self = this;
            self.indentItems = ko.observableArray([]);
            var mappedStockItems = jQuery.map(pStoreIndent, function (item) {
                return new IntentItem(item);
            });

            self.viewDetails = function (item) {
                var value = item.initialItem().quantity;
                var mainStoreValue = item.initialItem().mainStoreTransfer;
                var x = item.transferQuantity();

                if (x != null && x != '') {
                    if (parseInt(x) > parseInt(value)) {
                        jq().toastmessage('showNoticeToast', "Transfer quantity more than quantity indent!");
                        item.transferQuantity(0);
                    } else if (parseInt(x) > parseInt(mainStoreValue)) {
                        jq().toastmessage('showNoticeToast', "Transfer quantity more than quantity at hand!");
                        item.transferQuantity(0);
                    }
                }
            }

            self.transferIndent = function () {
//                jq("#indentsForm").submit();
                jq().toastmessage('showNoticeToast', "Submitting Form!");
            }

            self.refuseIndent = function () {
                if (confirm("Are you sure about this?")) {
                    jQuery('#tableIndent').remove();
                    jQuery("#refuse").val("1");
                    jQuery('#indentsForm').submit()
                } else {
                    return false;
                }

            }
            self.returnList = function () {
                window.location.href = emr.pageLink("inventoryapp", "main");

            }
            self.indentItems(mappedStockItems);
        }

        function IntentItem(initialItem) {
            var self = this;
            self.initialItem = ko.observable(initialItem);
            self.transferQuantity = ko.observable();
            self.compFormulation = ko.computed(function () {
                return initialItem.formulation.name + "-" + initialItem.formulation.dozage;
            });
        }

        var list = new IndentListViewModel();
        ko.applyBindings(list, jq("#indentlist")[0]);
    });//end of doc ready

</script>

<div class="patient-header new-patient-header">
    <div class="demographics">
        <h1 class="name">
            <span>${indent.name},<em>Drug Name</em></span>
            <span>${indent.store.name}  <em>From Store</em></span>
            <span>${indent.createdOn}  <em>Created On</em></span>
        </h1>
    </div>

    <div class="close"></div>
</div>

<div class="dashboard clear">
    <div class="info-section">
        <div class="info-header">
            <i class="icon-share"></i>

            <h3>Process Indent</h3>
        </div>
    </div>
</div>

<div id="indentlist">
    <div method="post" class="box" id="formMainStoreProcessIndent">

        <table id="tableIndent">
            <thead>
            <th>S. No.</th>
            <th>Drug</th>
            <th>Formulation</th>
            <th>Quantity Indent</th>
            <th>Transfer Qnty</th>
            <th>Qnty Available</th>
            </thead>
            <tbody data-bind="foreach: indentItems">
            <td data-bind="text: (\$index() + 1)"></td>
            <td data-bind="text: initialItem().drug.name"></td>
            <td data-bind="text: compFormulation()"></td>
            <td data-bind="text: initialItem().quantity"></td>
            <td><input data-bind="value: transferQuantity, event:{blur:\$root.viewDetails}"/></td>
            <td data-bind="text: initialItem().mainStoreTransfer"></td>
            </tbody>

        </table>

        <form method="post" id="indentsForm" style="padding-top: 10px">
            <input type="hidden" name="indentId" id="indentId" value="${indent.id}">
            <input type="hidden" id="refuse" name="refuse" value="">
            <textarea name="bill" data-bind="value: ko.toJSON(\$root)" style="display:none;"></textarea>

            <button data-bind="click:transferIndent, enable: indentItems().length > 0 " class="confirm"
                    style="float: right; margin-right: 2px;">Transfer</button>
            <button id="billVoid" data-bind="click: refuseIndent" class="cancel"
                    style="margin-left: 2px">Refuse This Indent</button>
            <button data-bind="click: returnList" class="cancel">Return List</button>

        </form>

    </div>
</div>
