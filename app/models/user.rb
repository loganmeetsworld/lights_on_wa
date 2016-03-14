class User < ActiveRecord::Base
  has_many :candidates_to_user
  has_many :candidates, through: :candidates_to_user
  
  def self.find_or_create_from_omniauth(auth_hash)
    user = self.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"] )
    if !user.nil?
      return user
    elsif auth_hash["provider"] == "developer"
      user            = User.new
      user.uid        = auth_hash["uid"]
      user.provider   = auth_hash["provider"]
      user.username   = auth_hash["info"]["username"]
      if user.save
        return user
      else
        return nil
      end
    elsif auth_hash["provider"] == "github"
      user            = User.new
      user.uid        = auth_hash["uid"]
      user.provider   = auth_hash["provider"]
      user.username   = auth_hash["info"]["username"]
      if !user.image_url.present?
        user.image_url = "blank.png"
      end
      if user.save
        return user
      else
        return nil
      end
    elsif auth_hash["provider"] == "twitter"
      user            = User.new
      user.uid        = auth_hash["uid"]
      user.provider   = auth_hash["provider"]
      user.username   = auth_hash["info"]["nickname"]
      if !user.image_url.present?
        user.image_url = "blank.png"
      end
      if user.save
        return user
      else
        return nil
      end
    end
  end
end
