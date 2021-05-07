global class NBRBServiceJob implements Schedulable {
    global void execute(SchedulableContext ctx) {
        NBRBService.getRate();
    }
}