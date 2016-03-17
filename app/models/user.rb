class User < ActiveRecord::Base
  has_many :candidates_to_user
  has_many :candidates, through: :candidates_to_user
  
  def self.find_or_create_from_omniauth(auth_hash)
    user = self.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"] )
    if !user.nil?
      return user
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

  def self.notifications(user)
    count = 0
    user.candidates.each do |candidate|
      if candidate.contributions.empty?
        latest_contributions = user.created_at
      else
        latest_contributions = candidate.contributions.max_by {|obj| obj.created_at }.created_at
      end
      if candidate.expenditures.empty?
        latest_expenditures = user.created_at
      else
        latest_expenditures = candidate.expenditures.max_by {|obj| obj.created_at }.created_at
      end

      if user.last_seen_at && (latest_contributions.to_date > user.last_seen_at || latest_expenditures.to_date > user.last_seen_at)
        count += 1
      end
    end

    return count
  end
end
