require_relative '../lib/utils/perfecto-utils'

# Do before each scenario
#
# saves scenario (test instance) in utils module
# that way it's available in the test
#
# Create a new webdriver instance
# Create a new reporting client
# Log a new test with scenario name
Before do |scenario|

  Utils::Cucumber.scenario = scenario

  host = 'demo.perfectomobile.com'
  securityToken ='eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4YmI4YmZmZS1kMzBjLTQ2MjctYmMxMS0zNTYyMmY1ZDkyMGYifQ.eyJpYXQiOjE2NDkxMDk1OTksImp0aSI6IjBhMDk4NmZkLTU2MTEtNDg3Yi04M2Q2LTNmNzA3Yzg5MzE2OSIsImlzcyI6Imh0dHBzOi8vYXV0aC5wZXJmZWN0b21vYmlsZS5jb20vYXV0aC9yZWFsbXMvZGVtby1wZXJmZWN0b21vYmlsZS1jb20iLCJhdWQiOiJodHRwczovL2F1dGgucGVyZmVjdG9tb2JpbGUuY29tL2F1dGgvcmVhbG1zL2RlbW8tcGVyZmVjdG9tb2JpbGUtY29tIiwic3ViIjoiN2YwNTllY2YtYmIzZi00ZTdlLTkxNDktMGNiZDcwMmY5NjAzIiwidHlwIjoiT2ZmbGluZSIsImF6cCI6Im9mZmxpbmUtdG9rZW4tZ2VuZXJhdG9yIiwibm9uY2UiOiI1Yzg3MTEzOS00NmRmLTQwZjktOWY2MC0xNGY5NDQ0N2Q0NTQiLCJzZXNzaW9uX3N0YXRlIjoiYzQ0M2JmMjItMDE2Yy00ZWFmLWJjNGQtZTcwZGE1MGViYTliIiwic2NvcGUiOiJvcGVuaWQgb2ZmbGluZV9hY2Nlc3MifQ.ubxCF-vdv2OhzGS-pXZQtTM-UD1AGxeqc6YnlqeFSxM'

  #capabilities = {
  #    :platformName => 'Android',
  #    :model => '',
  #    :platformVersion => '',
  #    :browserName => '',
  #    :browserVersion => '',
  #    :deviceName => '',
  #    :securityToken => securityToken
  #}

  #capabilities = {
  #  :platformName => 'Android',
  #  :platformVersion => '12',
  #  :platformBuild => 'SP1A.210812.016.G998WVLS5CVI8',
  #  :location => 'NA-CA-YYZ',
  #  :resolution => '1440x3200',
  #  :deviceStatus => 'CONNECTED',
  #  :manufacturer => 'Samsung',
  #  :model => 'Galaxy S21 Ultra',
  #  :securityToken => securityToken
  #}
  #capabilities = {
  #  :model => 'iPhone-11 Pro Max',
  #  :securityToken => securityToken
  #}
  capabilities = {
    :deviceName => '00008110-000E3D6636BA801E',
    :browserName => 'Safari',
    :securityToken => securityToken
  }

  Utils::Device.create_device host, capabilities
  Utils::Reporting.create_reporting_client(Utils::Device.driver, 'Ruby', 'Demo', 'Perfecto') # Optional, add more tags 
  Utils::Reporting.start_new_test scenario.name, 'RubyTest' # Optional, add more tags 

end

# Do after each scenarios
#
# check for scenario status
# if scenario success generates a successful test report,
# otherwise generates failure test report
#
# unless the driver nil quiting the session
After do |scenario|

  cfe1 = CustomField.new('Ruby', 'Demo')
  cfe2 = CustomField.new('CustomField', 'Demo')
  tec = TestContext::TestContextBuilder
         .withTestExecutionTags('PerfectoEndTag1' , 'PerfectoEndTag2')
         .withCustomFields(cfe1, cfe2)
         .build()
  if scenario.failed?
    Utils::Reporting.reportiumClient.testStop(TestResultFactory.createFailure(scenario.exception.message, scenario.exception, nil), tec)
  else
    Utils::Reporting.reportiumClient.testStop(TestResultFactory.createSuccess(), tec)
  end

  puts '========================================================================================'
  puts 'report-url: ' + Utils::Reporting.reportiumClient.getReportUrl
  puts '========================================================================================'

  unless Utils::Device.driver.nil?
    Utils::Device.driver.quit
  end

end