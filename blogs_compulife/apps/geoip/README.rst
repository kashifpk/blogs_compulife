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
