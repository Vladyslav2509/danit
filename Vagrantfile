DB_NAME = ENV.fetch("DB_NAME", "petclinic")
DB_USER = ENV.fetch("DB_USER", "petclinic_user")
DB_PASS = ENV.fetch("DB_PASS") {
  abort "Please export DB_PASS before running Vagrant"
}

DB_IP  = "192.168.56.11"
APP_IP = "192.168.56.10"

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"

  # DB VM
  

  config.vm.define "DB_VM" do |db|

    db.vm.hostname = "db-vm"

    db.vm.network "private_network",
      ip: DB_IP

    db.vm.provider "virtualbox" do |vb|
      vb.name = "PetClinic-DB"
      vb.memory = 1024
      vb.cpus = 1
    end

    db.vm.provision "shell" do |s|
      s.path = "db-provision.sh"

      s.env = {
        "DB_NAME" => DB_NAME,
        "DB_USER" => DB_USER,
        "DB_PASS" => DB_PASS,
        "DB_IP" => DB_IP
      }
    end

  end

  
  # APP VM
  

  config.vm.define "APP_VM" do |app|

    app.vm.hostname = "app-vm"

    app.vm.network "private_network",
      ip: APP_IP

    app.vm.provider "virtualbox" do |vb|
      vb.name = "PetClinic-APP"
      vb.memory = 2048
      vb.cpus = 2
    end

    app.vm.provision "shell" do |s|
      s.path = "app-provision.sh"

      s.env = {
        "DB_HOST" => DB_IP,
        "DB_PORT" => "3306",
        "DB_NAME" => DB_NAME,
        "DB_USER" => DB_USER,
        "DB_PASS" => DB_PASS,
        "APP_USER" => "appuser",
        "PROJECT_DIR" => "/opt/spring-petclinic",
        "APP_DIR" => "/home/appuser"
      }
    end

  end

end
