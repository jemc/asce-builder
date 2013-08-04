asce-builder
============

A tool made to extract active_support/core_ext from the rails code base and 
bundle it as a distinct gem, with reduced dependencies. The tool can be run 
as often as desired to keep the trimmed gem version synced with the latest 
progress on any stable release branch of rails.

The rails codebase is pulled from [the rails github](https://github.com/rails/rails).

The rails codebase is not my intellectual property, and is not being republished here.  
The asce-builder tool published here merely automates the process of pulling down 
the git repository and stripping out unwanted portions.

Copyright 2013 : Joe McIlvain
MIT Licensed.
