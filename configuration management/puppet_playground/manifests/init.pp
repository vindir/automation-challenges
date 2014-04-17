file { "/etc/widgetfile":
  path    => "/etc/widgetfile",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('site/widgetfile.erb')
}
