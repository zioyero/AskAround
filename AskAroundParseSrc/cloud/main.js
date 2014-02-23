
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// Before saving an ask, we need to populate the trustees field
// So that the ask actually goes out to someone
Parse.Cloud.beforeSave("AAAsk", function(request, response)
{

});

