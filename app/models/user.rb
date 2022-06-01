# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

  has_secure_password

  def comments
    my_id = self.id

    matching_comments = Comment.where({ :author_id => my_id })

    return matching_comments
  end
  
  def own_photos
    my_id = self.id

    matching_photos = Photo.where({ :owner_id => my_id })

    return matching_photos
  end

  def likes
    my_id = self.id

    matching_likes = Like.where({ :fan_id => my_id })

    return matching_likes
  end

  def liked_photos
    array_of_photo_ids = Array.new

    my_likes = self.likes

    my_likes.each do |a_like|
      the_photo = a_like.photo

      array_of_photo_ids.push(the_photo.id)
    end

    matching_photos = Photo.where({ :id => array_of_photo_ids })

    return matching_photos
  end

  def commented_photos
    array_of_photo_ids = Array.new

    my_comments = self.comments

    my_comments.each do |a_comment|
      the_photo = a_comment.photo

      array_of_photo_ids.push(the_photo.id)
    end

    matching_photos = Photo.where({ :id => array_of_photo_ids })

    return matching_photos
  end

  def sent_follow_requests
    my_id = self.id

    matching_followrequests = Followrequest.where({ :sender_id => my_id })

    return matching_followrequests
  end

  def received_follow_requests
    my_id = self.id

    matching_followrequests = Followrequest.where({ :recipient_id => my_id })

    return matching_followrequests
  end

  def accepted_sent_follow_requests
    return self.sent_follow_requests.where({ :status => "accepted" })
  end

  def accepted_received_follow_requests
    return self.received_follow_requests.where({ :status => "accepted" })
  end

  def followers
    array_of_follower_ids = self.accepted_received_follow_requests.pluck(:sender_id)

    return User.where({ :id => array_of_follower_ids })
  end

  def following
    array_of_leader_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)

    return User.where({ :id => array_of_leader_ids })
  end

  def feed
    array_of_leader_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)

    return Photo.where({ :owner_id => array_of_leader_ids })
  end

  def discover
    array_of_leader_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)

    all_leader_likes = Like.where({ :fan_id => array_of_leader_ids })

    array_of_discover_photo_ids = all_leader_likes.pluck(:photo_id)

    return Photo.where({ :id => array_of_discover_photo_ids })
  end
end
