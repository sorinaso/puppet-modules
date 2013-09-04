define ldap::define::schema($ensure = 'present',$content) {
	include ldap::params

	file { "${ldap::params::schema_directory}/${name}.schema":
		ensure 	=> $ensure,
		content => $content,
		owner	=> root,
		group 	=> root,
	}
}