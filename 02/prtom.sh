#!/bin/bash
packagesList=('git' 'gcc libffi-devel python-devel openssl-devel')
#--- Adding war for Task1
cp /vagrant/hello-world.war  /var/lib/tomcat/webapps/
systemctl restart tomcat
#-------------------------------
for pkg in ${packagesList[@]}
do
	yum install -y ${pkg}
done
#-----------Task2---------------
##---I need python3-------------
if [! -d $HOME/.pyenv] 
then
curl -L  https://raw.github.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
echo "{content_for_python}" >> $HOME/.bashrc
exec "${SHELL}"
fi
pyenv install 3.6.0
pyenv global 3.6.0
pip3 install requests
python3 zabbix.py 

