asce-builder
============

## Warning

Don't use this code or the gem it produces - it's not maintained, and was a fool's errand to begin with.  It's easier to just write new libraries than to disentangle the mess that is activesupport.

The code is still hosted here for historical purposes only.  The gem it creates is yanked from rubygems to prevent accidental use, but if anyone should want to try this fool's errand again or use the gem name for something else, I can transfer the gem rights to them.

## Description

A tool made to extract active_support/core_ext from the rails code base and 
bundle it as a distinct gem, with reduced dependencies. The tool can be run 
as often as desired to keep the trimmed gem version synced with the latest 
progress on any stable release branch of rails.

The rails codebase is pulled from [the rails github](https://github.com/rails/rails).

The rails codebase is not my intellectual property, and is not being republished here.  The asce-builder tool published here merely automates the process of pulling down the git repository and stripping out unwanted portions.
