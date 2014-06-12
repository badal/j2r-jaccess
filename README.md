# JacintheReports : Jaccess part

## Description
  j2r-jaccess is the bottom part of J2R extracted from the full version

## Version
  1.2

## Synopsis
  j2r-jaccess is a gem to be called by j2r-core. It provides the basic query and update methods.

## Usage
  needs DATA = ENV['J2R_DATA'] to give the path to the parameter directory

## Parameters
  * Default DATA directories are in 'j2r/jaccess/files_and_directories.rb'
  * Connection parameters are in the file 'DATA/config/connect.ini'
  * Extended fields and joins building parameters are in 'DATA/config/joins.ini'
  
## Installation (and each time the database structure changes)
  * To parametrize and build the DATA files (each time the database structure changes),
  run the file 'update.rb' (in the directory 'database_update')
  * The loaded files are in the DATA directory
  * See the detailed documentation

## More documentation
   See the Yardoc/RDoc documentation.

## Bugs

## Source and issues
   [![Code Climate](https://codeclimate.com/github/badal/j2r-jaccess.png)](https://codeclimate.com/github/badal/jacman-qt)

   * Source code on repository [GitHub](https://github.com/badal/j2r-jaccess)
   * [Issue Tracker](https://bitbucket.org/mdemazure/j2r/issues?status=new&status=openissues/new)
   
## Copyright
   (c) 2014, Michel Demazure

## License
   See LICENSE

## Author
   Michel Demazure
   firstname at name dot com
