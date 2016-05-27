class UserKeys
  def keys
    load_keys.to_json
  end

  def key(username)
    load_key(username).to_json
  end

  private

  def load_key(username)
    user = User.where(username: username).last
    return { error: "User #{username} not found." } unless user
    hash = {}
    hash[user.username] = user.api_key
    hash
  end

  def load_keys
    k = {}
    User.all.each do |user|
      k[user.username] = user.api_key
    end
    k
  end
end
