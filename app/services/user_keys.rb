class UserKeys
  def keys
    load_keys.to_json
  end

  private

  def load_keys
    k = {}
    User.all.each do |user|
      k[user.username] = user.api_key
    end
    k
  end
end
