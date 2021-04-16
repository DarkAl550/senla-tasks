public class TimeZoneController {
    public String timeZoneValue {get; set;}
    public String returnValue {get; set;}
    
    public PageReference  calculateTime(){
        Matcher regex = Pattern.compile('[+-]?([0-9]*[.])?[0-9]+').matcher( this.timeZoneValue );
        if(regex.matches()){
            Integer convertedTimeZoneValue = Double.valueOf(timeZoneValue).intValue();
            Datetime dateNow = Datetime.now();
            Datetime newDate = dateNow.addHours(convertedTimeZoneValue);
            this.returnValue = String.valueOf(newDate.hourGMT() +':'+newDate.minute()+':'+newDate.second());
        }else{
            this.returnValue = 'Invalid value!';
        }
		return null;
    }
    
}