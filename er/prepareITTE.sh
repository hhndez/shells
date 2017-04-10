#!/bin/bash

WORKSPACE=~/Repositories/ITTE_WE/dashboard

cd $WORKSPACE


cdt2 package link ../dcomlib/
cdt2 package link ../dcomcore/
cdt2 package link ../dcomwidget/

cdt2 package link ../accounts/
cdt2 package link ../bamsupdate/

cdt2 package link ../dcomadmin/
cdt2 package link ../eittesd
cdt2 package link ../hardwaredetails/
cdt2 package link ../podadmin/
cdt2 package link ../sdadmin/
cdt2 package link ../allassets/
cdt2 package link ../bookings/
cdt2 package link ../dcim
cdt2 package link ../netsimvms/
cdt2 package link ../ecutcomp/
cdt2 package link ../dnsrecords/
cdt2 package link ../cloudmon/
cdt2 package link ../inframon/
/dashboard$ cdt2 package link ../podmon/
cdt2 package link ../ddputil/
cdt2 package link ../podutil/


