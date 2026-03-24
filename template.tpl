___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "GA4 - Data Stream Map",
  "categories": ["UTILITY", "TAG_MANAGEMENT"],
  "description": "Easily route data to a dev stream instead of production. Returns your dev ID when debug mode is active or on specific hostnames, keeping your live GA4 reports clean and accurate.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "prod_sid",
    "displayName": "Production Stream ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^([Gg]|[Uu][Aa])\\-.*"
        ],
        "errorMessage": "Must be a valid stream ID",
        "enablingConditions": []
      },
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": "G-XXXXXXXX"
  },
  {
    "type": "TEXT",
    "name": "dev_sid",
    "displayName": "Development Stream ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^([Gg]|[Uu][Aa])\\-.*"
        ],
        "errorMessage": "Must be a valid stream ID"
      },
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": "G-XXXXXXXX"
  },
  {
    "type": "CHECKBOX",
    "name": "db_mode_cbx",
    "checkboxText": "Send events to Production while in Debug Mode",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Events are automatically sent to the development stream while in debug mode. Check this box to override this setting."
  },
  {
    "type": "GROUP",
    "name": "dev_pattern",
    "displayName": "Non Production domain URL patterns",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": []
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "domain_list",
    "displayName": "URL Pattern",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "",
        "name": "url",
        "type": "TEXT"
      }
    ],
    "help": "Pattern used to identify non-production environments (\u003cem\u003eEg: dev, stage, uat, testing\u003c/em\u003e).\nEvents will be sent to the development stream if the hostname partially matches any of these patterns."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const getContainerVersion = require('getContainerVersion');
const container_version = getContainerVersion();

const getUrl = require('getUrl');
const hostname = getUrl('host');

const log=require('logToConsole');

var db_mode  = container_version.debugMode,
    db_mode_cbx = data.db_mode_cbx,
    env = container_version.environmentName,
    prod_sid = data.prod_sid,
    dev_sid = data.dev_sid,
    domain_list = data.domain_list||[];

if(db_mode===true||db_mode==1||db_mode=="true"){
  return (db_mode_cbx)?prod_sid:dev_sid;
}

if(data.environment && data.environment.toLowerCase().match("dev|stag|test|uat")){
  return dev_sid;
}


for (var i = 0; i < domain_list.length; i++) { 
  if(hostname.match(domain_list[i].url)){
    return dev_sid;
  }
}
return prod_sid;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 3/13/2025, 9:34:09 AM


