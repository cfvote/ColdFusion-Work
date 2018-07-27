# ColdFusion-Work
Some CF utils and random testing files I've used in the process of upgrading/maintaining the legacy ColdFusion code. Also includes any other random CF program I've written at work.

## File Descriptions

* index.cfm --- landing page for my testing folder and any other temporary tests I might run
* application.cfc --- component called by local CF server for my testing folder
* Barrett-Utils.cfc --- useful functions that can be reused in other CF programs
* Testing
  * pentonAPI-test.http  --- Example using a cool VSCode extension to perform HTTP Requests
  * BinaryDecimalConverter.cfc --- A simple binary/decimal converter used in my introduction to mxunit testing
  * BinaryDecimalTest.cfc --- My introduction to mxunit testing
* Batch Scripts
  * CF-Server.bat  --- Stops local CF server instance and then starts it
  * Update-Source.bat -- Updates/Cleans CF and Java code using SVN. Moves Java jars to folder for local CF server
* Intro-To-CF --- Introductory CF, learning syntax, etc.

## Useful Links and Answers
 * ColdFusion cfscript docs https://cfdocs.org/functions
 * Using custom tags in cfscript  https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-tags/tags-r-s/cfscript.html
 * General converting cftags to cfscript https://github.com/tonyjunkes/cfml-tags-to-cfscript
 * Writing mxunit tests https://www.bennadel.com/blog/2394-writing-my-first-unit-tests-with-mxunit-and-coldfusion.htm
 * mxunit repo https://github.com/mxunit/mxunit
 
 
 ## Things I might forget
  * Update your jars...
  * If managers or displays are edited, exit quote and execute ?reloadapp
  * If WC manual is edited, exit quote and execute ?reloadapp
  * If javascript files are edited do CTRL+F5
  * In XML manuals, do **NOT** comment out with three dashes or it will break your manual...
  * Npm install is still broken. To fix sign into superuser and just swap the two npm paths. Idk why this works.
  * JSON returns fields in caps unless it is refrerenced with square braces ex:  json["field"]
  
