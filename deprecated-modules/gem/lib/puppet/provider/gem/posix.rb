require 'puppet/file_serving/content'
require 'puppet/error'

Puppet::Type.type(:gem).provide(:posix) do
  commands :gem => 'gem'

  def self.instances
    ret = []

    packages = gem('query')

    packages.split("\n").each do |line|
      matcher = /([a-zA-Z0-9-]+)\s[(](.*)[)]$/.match(line)
      name, version = matcher[1], matcher[2].split(", ")

      Puppet.debug("Gem instance collected: name:#{name}, version: #{version}")

      ret << new(:name => name, :ensure => :present, :version => version)
    end

    ret
  end

  def self.prefetch(packages)
    instances.each do |prov|
      packages[prov.name].provider = prov if packages[prov.name]
    end
  end

  def version
    @property_hash[:version]
  end

  def version=(value)
    with_gem { |gem| gem("install", gem.path) }
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    with_gem { |gem| gem("install", gem.path) }
  end

  def destroy
    gem('uninstall', resource[:name], "-v", resource[:version])
  end

  private

  def with_gem(&block)
    content = Puppet::FileServing::Content.indirection.find(
        resource[:source]
    ).content

    tmp_gem_path = "/tmp/puppet_temp_gem.gem"

    raise Puppet::DevError.new("El archivo #{tmp_gem_path} ya existe.") if File.exists?(tmp_gem_path)

    begin
      tmp_gem = File.open(tmp_gem_path, "w")
      tmp_gem.write(content)
      tmp_gem.close

      yield tmp_gem
    ensure
      File.delete(tmp_gem_path)
    end
  end
end