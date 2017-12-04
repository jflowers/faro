loaded_vagrant_gem_path = Gem::Specification.find_by_name('vagrant').gem_dir

require "#{loaded_vagrant_gem_path}/plugins/provisioners/ansible/provisioner/base.rb"

module VagrantPlugins
  module Ansible
    module Provisioner

      class Base < Vagrant.plugin("2", :provisioner)
        def prepare_common_environment_variables
          @environment_variables["PYTHONUNBUFFERED"] = 1
          @environment_variables["ANSIBLE_FORCE_COLOR"] = "true" if @machine.env.ui.color?
          @environment_variables["ANSIBLE_NOCOLOR"] = "true" if !@machine.env.ui.color?

          if config.galaxy_roles_path
            galaxy_roles_path = get_galaxy_roles_path
            unless ENV['ANSIBLE_ROLES_PATH'].nil?
              galaxy_roles_path = "#{ENV['ANSIBLE_ROLES_PATH']}:#{galaxy_roles_path}"
            end
            @environment_variables["ANSIBLE_ROLES_PATH"] =  galaxy_roles_path
          end

          prepare_ansible_config_environment_variable
        end
      end
    end
  end
end
