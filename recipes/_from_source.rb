include_recipe 'yum-epel::default'
include_recipe 'build-essential::default'

package %w(libbsd-devel openssl-devel sendmail-devel lua-devel libdb-devel)

directory node['opendkim']['source']['path'] do
  recursive true
end

src_file_name = format(node['opendkim']['source']['name'], file_prefix: node['opendkim']['source']['file_prefix'], version: node['opendkim']['source']['version'])
src_file_url = format(node['opendkim']['source']['url'], name: src_file_name)
src_filepath = "#{node['opendkim']['source']['path']}/#{src_file_name}.tar.gz"

remote_file src_file_url do
  source src_file_url
  checksum node['opendkim']['source']['checksum']
  path src_filepath
  backup false
end

compile_flags = node['opendkim']['source']['compile_flags']

bash 'compile_opendkim_source' do
  cwd File.dirname(src_filepath)
  code <<-EOH
    tar zxf #{File.basename(src_filepath)} -C #{File.dirname(src_filepath)} &&
    cd #{src_file_name} &&
    ./configure #{compile_flags.join(' ')} &&
    make -j#{node['cpu']['total']} &&
    make install
  EOH
end

systemd_service 'opendkim' do
  unit_description 'OpenDKIM service'
  install_wanted_by 'multi-user.target'
  service_user node['opendkim']['user']
  service_group node['opendkim']['group']
  service_type 'forking'
  service_exec_start "#{node['opendkim']['source']['prefix']}/sbin/opendkim -x #{node['opendkim']['conf_file']} -P /var/run/opendkim/opendkim.pid"
  service_restart 'always'
  service_restart_sec 10
  service_pid_file '/var/run/opendkim/opendkim.pid'
end
