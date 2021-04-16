@isTest
public class TimeZoneControllerTest {
	@isTest
    static void testCalculateTime(){
        TimeZoneController controller1 = new TimeZoneController();
        controller1.timeZoneValue = '12';
                
        TimeZoneController controller2 = new TimeZoneController();
        controller2.timeZoneValue = '1dsf2';
        
        Test.startTest();
        	controller1.calculateTime();
        	controller2.calculateTime();
        Test.stopTest();
        Datetime dateNow = Datetime.now();
        System.assertEquals(dateNow.hourGMT() + Integer.valueOf(controller1.timeZoneValue), Integer.valueOf(controller1.returnValue.split(':')[0]));
        System.assert(!String.isEmpty(controller1.returnValue));
        System.assertEquals(controller2.returnValue, 'Invalid value!');

    }
}