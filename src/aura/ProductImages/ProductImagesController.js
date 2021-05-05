({
    doInit : function(component, event, helper) {
        helper.getAttachment(component);
    },

    selectImageName : function(component, event, helper){
        var id = event.target.id;
        console.log(id);
    },

})