
Vagrant.configure("2") do |config|
  ip=["192.168.100.10","192.168.100.11"] 
  box="sbeliakou/centos"
  servers=[
  {
    :hostname => "zabbix",
    :ip => ip[0],
    :box => "sbeliakou/centos",
    :ram => 1024,
    :cpu => 2,
    :script => "zabbix.sh"
  },
  {
    :hostname => "httpdtomcat",
    :ip => ip[1],
    :box => "sbeliakou/centos",
    :ram => 2048,
    :cpu => 4,
    :script =>  "httpd_tomcat.sh"
  }
]
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
            
            end
            node.vm.provision 'shell' , path: machine[:script]
            
        end
    end

end
