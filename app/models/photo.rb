# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  def poster
    my_owner_id = self.owner_id

    matching_users = User.where({ :id => my_owner_id })

    the_user = matching_users.at(0)

    return the_user
  end

  def comments
    my_id = self.id

    matching_comments = Comment.where({ :photo_id => my_id })

    return matching_comments
  end

  def likes
    my_id = self.id

    matching_likes = Like.where({ :photo_id => my_id })

    return matching_likes
  end

  def fans
    array_of_user_ids = Array.new

    my_likes = self.likes

    my_likes.each do |a_like|
      the_fan = a_like.fan

      array_of_user_ids.push(the_fan.id)
    end

    matching_users = User.where({ :id => array_of_user_ids })

    return matching_users
  end

  def fan_list
    return self.fans.pluck(:username).to_sentence
  end
end
