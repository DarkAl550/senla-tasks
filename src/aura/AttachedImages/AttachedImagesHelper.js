({
    getAttachment : function(component) {
        let action = component.get("c.getAttachments");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const result = response.getReturnValue();
                const recordImages = [];
                for(let i=0; i<result.length; i++){
                    recordImages.push(
                        { "name" : result[i].Name, "url" : "/servlet/servlet.FileDownload?file=" + result[i].Id}
                    );
                }
                component.set("v.recordImages", recordImages);
            }
        });
        $A.enqueueAction(action);
    }
})