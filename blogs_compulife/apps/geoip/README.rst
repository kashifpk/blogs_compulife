pyckapps.geoip
==============

Pluggable GeoIP app for PyCK framework based on Maxmind's GeoIP databases and library (geoip2).
This app goes under the apps folder in a pyck project and cannot be used standalone(without modification).
If you're using git to manage your project you can put this app's repo as a subtree without your project.

For example you can add this as a subtree to your PyCK project like::


    git remote add geoip git@github.com:kashifpk/pyckapps.geoip.git
    git subtree add --prefix myproject/apps/geoip geoip master

Later if you want to pull latest changes (any updates to the app) you can do::

    git subtree pull --prefix myproject/apps/geoip geoip master


Setup Instructions
-------------------

This app requires the geoip2 library from maxmind so after including this app you'll need to run::

    python setup.py develop

Also in your projects ini file (development.ini, production.ini etc) you need to specify the location of
maxmind's database that you want to use in the "[app:main]" section of the configuration, something like::

    [app:main]
    
    # some code
    
    geoip_db = /path/to/geoip/db/GeoLite2-City.mmdb

Demo
----

A working demo of the latest code can be fount at: `tools.compulife.com.pk <http://tools.compulife.com.pk/geoip>`_
