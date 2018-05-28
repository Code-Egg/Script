# Install Script:
Install OpenLiteSpeed + PHP71 + Magento1.9 on Centos7x64<br>
Defualt OpenLiteSpeed: admin/123456<br>
Default Magento Database: magento/magento/magento<br>
Default mysql: root/123456<br>
How to use:
Install this script directly without any parameter, then install magento settings from web.<br>

# ab-burst-testing
Need to edit you domain instead of example.com then excecute the bash script.
Test URL by ab command with default 5 times and average the middle of requests per seconds.
./ab-burst-testing
Test http://example.com/ 5 times with ab total: 1000 concurrent: 10
sorted='([0]="11030.83" [1]="9310.90" [2]="8876.90" [3]="8467.83" [4]="6422.28")'
Round: 1
num: 9311
total: 9311
Round: 2
num: 8877
total: 18188
Round: 3
num: 8468
total: 26656
Calculating Total/Rounds 26656/3
Requests per second everage: 8885.33
