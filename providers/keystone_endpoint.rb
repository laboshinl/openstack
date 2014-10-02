action :create do
  def service_id 
    vg = Mixlib::ShellOut.new("keystone service-list | grep id | awk '{print $2}'")
    vg.run_command
    vg.error!
    return vg.stdout[0..-2]
  end
  new_resource.updated_by_last_action(true)
end
