({
    getAttachment : function(component, event) {
        var action = component.get("c.getProductAttachments");
        action.setParams({ productId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let productImages = [];
                for(let i=0; i<result.length; i++){
                    productImages.push(
                        { "name" : result[i].Name, "url" : "/servlet/servlet.FileDownload?file=" + result[i].Id}
                    );
                }
                component.set("v.productImages", productImages);
                console.log(component.get("v.productImages"));
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})