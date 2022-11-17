require 'perfecto-reporting'
require 'appium_lib'
require 'selenium-webdriver'

desired_caps = {
        #  1. Replace <<cloud name>> with your perfecto cloud name (e.g. demo is the cloudName of demo.perfectomobile.com).
    appium_lib: {
        server_url: 'https://%s.perfectomobile.com/nexperience/perfectomobile/wd/hub' % "demo",  
    },
    caps: {
        #  2. Replace <<security token>> with your perfecto security token.
        "perfecto:securityToken": 'eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4YmI4YmZmZS1kMzBjLTQ2MjctYmMxMS0zNTYyMmY1ZDkyMGYifQ.eyJpYXQiOjE2NjgyNTA0MDUsImp0aSI6IjY2MDVkNjJkLWUzOGYtNDMxZC1iMjIyLWQyZGJjMmVjOTRjNSIsImlzcyI6Imh0dHBzOi8vYXV0aC5wZXJmZWN0b21vYmlsZS5jb20vYXV0aC9yZWFsbXMvZGVtby1wZXJmZWN0b21vYmlsZS1jb20iLCJhdWQiOiJodHRwczovL2F1dGgucGVyZmVjdG9tb2JpbGUuY29tL2F1dGgvcmVhbG1zL2RlbW8tcGVyZmVjdG9tb2JpbGUtY29tIiwic3ViIjoiZGNiZjE3MTctNDAwMC00NjZjLThlM2QtOGViMDM0MmUxMjVhIiwidHlwIjoiT2ZmbGluZSIsImF6cCI6Im9mZmxpbmUtdG9rZW4tZ2VuZXJhdG9yIiwibm9uY2UiOiIyMjAzZDUzNy1iZDMzLTQ2ODMtYjk0ZC00YTAwYjNhYjk1ZmUiLCJzZXNzaW9uX3N0YXRlIjoiYTcyNTVmNjAtMjJlYi00MWU2LTgzMTUtM2FhMTA4YjcxNDM2Iiwic2NvcGUiOiJvcGVuaWQgb2ZmbGluZV9hY2Nlc3MifQ.YjyFcKSYMzmdzbOSGVg8PmIaj8_JJmoJl2sqioP4lXk',
        
        # 3. Set device capabilities.
        platformName: 'Android',
        model: 'Galaxy S.*',

        # Set other capabilities.
        browserName: 'mobileOS',
        useAppiumForWeb: true,
        openDeviceTimeout: 5
    }
}
# Initialize the Appium driver
@driver = Appium::Driver.new(desired_caps, true).start_driver

# Setting implicit wait
@driver.manage.timeouts.implicit_wait = 5

# Initialize Smart Reporting
if ENV["jobName"] != nil
    perfectoExecutionContext = PerfectoExecutionContext.new(PerfectoExecutionContext::PerfectoExecutionContextBuilder
    .withWebDriver(@driver).withJob(Job.new(ENV["jobName"], ENV["jobNumber"].to_i)).build)
else
    perfectoExecutionContext = PerfectoExecutionContext.new(PerfectoExecutionContext::PerfectoExecutionContextBuilder
            .withWebDriver(@driver).build)
end
@reportiumClient = PerfectoReportiumClient.new(perfectoExecutionContext)
tec = TestContext::TestContextBuilder.build()
@reportiumClient.testStart("Selenium Ruby Android Sample", tec)

begin
    timeout = 30
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    search = "perfectomobile"
    @reportiumClient.stepStart('Navigate to Google');
    @driver.get('https://www.google.com');
    @reportiumClient.stepEnd();

    @reportiumClient.stepStart('Search for ' + search);
    wait.until{ @driver.find_element(:name => 'q') }
    @driver.find_element(:name => 'q').send_keys(search)
    @driver.find_element(:name => 'q').send_keys(Keys.return)
    @reportiumClient.stepEnd();

    @reportiumClient.stepStart('Verify Title');
    expectedText = "perfectomobile - Google Search";
    @reportiumClient.reportiumAssert(expectedText, @driver.title === expectedText)
    @reportiumClient.stepEnd();
            
    @reportiumClient.testStop(TestResultFactory.createSuccess(), tec)

rescue Exception => exception
    @exception = exception
    @reportiumClient.testStop(TestResultFactory.createFailure(@exception.exception.message, @exception.exception, nil), tec)
    raise exception
ensure
    # Prints the report url
     puts 'Report url - ' + @reportiumClient.getReportUrl
     
    #Quits the driver
    @driver.quit
    puts "Ruby Android Execution completed"
end