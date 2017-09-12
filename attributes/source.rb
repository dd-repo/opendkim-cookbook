default['opendkim']['packages']['from_source'] = true

default['opendkim']['source']['file_prefix'] = 'opendkim'
default['opendkim']['source']['version'] = '2.10.3'
default['opendkim']['source']['name'] = '%{file_prefix}-%{version}'
default['opendkim']['source']['url'] = 'https://downloads.sourceforge.net/project/opendkim/%{name}.tar.gz'
default['opendkim']['source']['checksum'] = '43a0ba57bf942095fe159d0748d8933c6b1dd1117caf0273fa9a0003215e681b'

default['opendkim']['source']['path'] = '/tmp'

default['opendkim']['source']['prefix'] = '/usr/local'

default['opendkim']['source']['compile_flags'] = [
  "--prefix=#{node['opendkim']['source']['prefix']}",
  '--enable-stats',
  '--enable-query_cache',
  '--with-lua',
  '--with-db',
  '--with-openssl'
]
