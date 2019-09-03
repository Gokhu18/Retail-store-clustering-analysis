libname SC"/home/harshithreddyv0/Clustering";
run;

Proc import datafile="/home/harshithreddyv0/Clustering/clustering_data-class14-1.csv"
Dbms=csv
out=SC.Storecluster;
run;

proc means data=Sc.storecluster n nmiss;
run;

proc freq data=sc.storecluster;
tables state;
run;

data sc.store;
set sc.storecluster;
Salepersqft = sale/size;
pcat1 = cat1 / sum(cat1,cat2,cat3,cat4);
pcat2 = cat2 / sum(cat1,cat2,cat3,cat4);
pcat3 = cat3 / sum(cat1,cat2,cat3,cat4);
pcat4 = cat4 / sum(cat1,cat2,cat3,cat4);
run;

proc means data=sc.store;
run;

proc standard data = sc.store mean = 0 std = 1 out = sc.store1;
var Salepersqft pcat1-pcat4;
run;

data sc.store1;
set sc.store1;
Salepersqft3 = salepersqft * 3;
run;


proc fastclus data=sc.store1 out=sc.clustered maxclusters=6;
var salepersqft3 pcat1-pcat4;
run;

data sc.clustered;
set sc.clustered;
keep store_num cluster;
run;

proc sort data=sc.clustered;
by store_num;
run;

proc sort data=sc.store;
by store_num;
run;

data sc.ClusteredFinal;
merge sc.clustered(in=a) sc.store(in=b);
by store_num;
if (a and b);
run;

proc sort data=sc.clusteredfinal;
by cluster;
run;

proc means data=sc.clusteredfinal;
var salepersqft pcat1-pcat4;
by cluster;
run;

proc means data=sc.ClusteredFinal;
var salepersqft pcat1-pcat4;
run;

proc freq data=sc.clusteredfinal;
tables cluster*state/ norow nocol;
run;

proc means data=sc.clusteredfinal mean;
var size;
by cluster;
run;





