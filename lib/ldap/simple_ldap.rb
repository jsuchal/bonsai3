class SimpleLDAP
	require 'net/ldap'
  def self.authenticate(login, password, host, port, base, attributes = ['cn'])
		ldap = Net::LDAP.new
    ldap.host = host
    ldap.port = port

    username = "uid=#{login},#{base}"

    ldap.auth(username,password)
    result = nil
    begin
      result = ldap.bind_as(
      	:base => "ou=People,dc=stuba,dc=sk",
      	:filter => "uid="+login,
      	:password => password)
    	p result.first.cn
    rescue LDAP::Error, LDAP::ResultError
      return nil
    end
    result
  end

  class Stub
    def self.authenticate(login, password, host = nil, port = nil, base = nil, attributes = ['cn'])
      return nil unless login == password
  		entry = Net::LDAP::Entry.new
			entry.cn = login
			data = []
      data << entry
      data
    end
	end
end