Puppet::Type.newtype(:gem) do
  ensurable

  newparam(:name, :namevar => true) do
    desc "Gem name"

  end

  newparam(:source) do
    desc "Source of .gem"
    validate do |value|
      fail("Can't find source #{value}.") \
        if Puppet::FileServing::Content.indirection.find(value).nil?
    end
  end

  newproperty(:version, :array_matching => :all) do
    desc "Version of the gem package."
    validate do |value|
      fail("Invalid version #{value}") unless value =~ /^[0-9,\.]+$/
    end
  end
end
