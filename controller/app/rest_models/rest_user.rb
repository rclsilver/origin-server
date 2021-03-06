class RestUser < OpenShift::Model
  attr_accessor :id, :login, :consumed_gears, :capabilities, :plan_id, :usage_account_id, :links, :max_gears, :created_at

  def initialize(cloud_user, url, nolinks=false)
    [:id, :login, :consumed_gears, :plan_id, :usage_account_id, :created_at].each{ |sym| self.send("#{sym}=", cloud_user.send(sym)) }

    self.capabilities = cloud_user.get_capabilities
    self.max_gears = capabilities["max_gears"]
    self.capabilities.delete("max_gears")

    unless nolinks
      @links = {
        "LIST_KEYS" => Link.new("Get SSH keys", "GET", URI::join(url, "user/keys")),
        "ADD_KEY" => Link.new("Add new SSH key", "POST", URI::join(url, "user/keys"), [
          Param.new("name", "string", "Name of the key"),
          Param.new("type", "string", "Type of Key", SshKey.get_valid_ssh_key_types()),
          Param.new("content", "string", "The key portion of an rsa key (excluding ssh-rsa and comment)"),
        ]),
      }
      @links["DELETE_USER"] = Link.new("Delete user. Only applicable for subaccount users.", "DELETE", URI::join(url, "user"), nil, [
        OptionalParam.new("force", "boolean", "Force delete user. i.e. delete any domains and applications under this user", [true, false], false)
      ]) if cloud_user.parent_user_id
    end
  end

  def to_xml(options={})
    options[:tag_name] = "user"
    super(options)
  end
end
