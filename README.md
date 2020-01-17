# README

TODO list:

* Are we going to have different styles for File Monitor and RJMC?
* Add localization
* Add Footer?
* Look into passwords
* Review UI: host, task_name, pattern, switch source and target?
* Conditional switch between username/password and access keys in UI
  we can still use username/password, or can add access_key_id, secret_access_key
  to task table
* modify Files part of UI: nested table instead of inspect, fix sizing 
* How to clean up jobs? I had to go in rails console, otherwise I would have to remove 500 FileMonitorJobs one by one.
* For now the tool is working only for SFTP to S3 transfer. Extend to another types. The main block: different interfaces for 
  IOStreams::Paths #each_child method for different streams.
* Dockerize application
* Improve email look/language
* Better error handeling/error propagation. For example, FileMonitorJob just stays in `running` state, when authentication is failed due to wrong password, etc 
* specs for UI 


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
