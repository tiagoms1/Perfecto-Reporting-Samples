require 'rubygems'
require 'pry'
require 'appium_capybara'

      desired_caps = {
        :model => 'Galaxy S21 Ultra',
        :"perfecto:securityToken" => 'eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4YmI4YmZmZS1kMzBjLTQ2MjctYmMxMS0zNTYyMmY1ZDkyMGYifQ.eyJpYXQiOjE2NDkxMDk1OTksImp0aSI6IjBhMDk4NmZkLTU2MTEtNDg3Yi04M2Q2LTNmNzA3Yzg5MzE2OSIsImlzcyI6Imh0dHBzOi8vYXV0aC5wZXJmZWN0b21vYmlsZS5jb20vYXV0aC9yZWFsbXMvZGVtby1wZXJmZWN0b21vYmlsZS1jb20iLCJhdWQiOiJodHRwczovL2F1dGgucGVyZmVjdG9tb2JpbGUuY29tL2F1dGgvcmVhbG1zL2RlbW8tcGVyZmVjdG9tb2JpbGUtY29tIiwic3ViIjoiN2YwNTllY2YtYmIzZi00ZTdlLTkxNDktMGNiZDcwMmY5NjAzIiwidHlwIjoiT2ZmbGluZSIsImF6cCI6Im9mZmxpbmUtdG9rZW4tZ2VuZXJhdG9yIiwibm9uY2UiOiI1Yzg3MTEzOS00NmRmLTQwZjktOWY2MC0xNGY5NDQ0N2Q0NTQiLCJzZXNzaW9uX3N0YXRlIjoiYzQ0M2JmMjItMDE2Yy00ZWFmLWJjNGQtZTcwZGE1MGViYTliIiwic2NvcGUiOiJvcGVuaWQgb2ZmbGluZV9hY2Nlc3MifQ.ubxCF-vdv2OhzGS-pXZQtTM-UD1AGxeqc6YnlqeFSxM'
      }

#secToken: eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyODhmZjQyYy0zMDViLTQ2YWEtYjhlOC00ZjI5ZjI1YjA2MDgifQ.eyJpYXQiOjE2NDgyMjUyMDUsImp0aSI6IjE3NTNmM2Y5LTM2OGMtNGY0Yi1hOTJkLTcyZWRmYTJmNWEwNiIsImlzcyI6Imh0dHBzOi8vYXV0aDYucGVyZmVjdG9tb2JpbGUuY29tL2F1dGgvcmVhbG1zL3ByaW1lY29udHJvbC1wZXJmZWN0b21vYmlsZS1jb20iLCJhdWQiOiJodHRwczovL2F1dGg2LnBlcmZlY3RvbW9iaWxlLmNvbS9hdXRoL3JlYWxtcy9wcmltZWNvbnRyb2wtcGVyZmVjdG9tb2JpbGUtY29tIiwic3ViIjoiOTg4MDAxZDktZjQ2ZC00NTdiLWI5YzEtNzRhNGRiMmIwN2RjIiwidHlwIjoiT2ZmbGluZSIsImF6cCI6Im9mZmxpbmUtdG9rZW4tZ2VuZXJhdG9yIiwibm9uY2UiOiIwOGU0ODY3Zi1iNzY3LTRiZjAtOTlhZC1jNGU1ZDZiNTMxZmIiLCJzZXNzaW9uX3N0YXRlIjoiZDJlMThjNDQtNmUzZC00MzkyLThmYjYtNzIzMjUwYTQ3NTZkIiwic2NvcGUiOiJvcGVuaWQgZW1haWwgcHJvZmlsZSBvZmZsaW5lX2FjY2VzcyJ9.e1UC7VJr2s_b6Pr48glVz_y5Rvh1CcA5aGh0RRwLjHs
#url = 'https://primecontrol.perfectomobile.com/nexperience/perfectomobile/wd/hub/'

url = 'http://demo.perfectomobile.com/nexperience/perfectomobile/wd/hub/'

Capybara.register_driver :appium do |app|
    appium_lib_options = {
      server_url: url
    }
    all_options = {
      appium_lib: appium_lib_options,
      caps: desired_caps
    }
   Appium::Capybara::Driver.new app, **all_options
end

Capybara.default_driver = :appium

capy_driver = Capybara.current_session.driver
#binding.pry #O comando abaixo que dá 401
capy_driver.browser