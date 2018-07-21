class Api::V1::FriendshipsController < ApplicationController
  def create
    user1 = User.find_by(email: params['friends'][0])
    user2 = User.find_by(email: params['friends'][1])
    unless friendship_exists?(user1, user2)
      friendship = user1.friendships.build(friend_id: user2.id)
      if friendship.save
        render json: { success: true }
      else
        render json: { error: 'Failed to add as friend' }
      end
    else
      render json: { error: 'Users are already friends' }
    end

  end

  private

  def friendship_exists?(user, friend)
    if user.friendships.exists?(friend_id: friend.id) &&
      friend.inverse_friendships.exists?(user_id: user.id)
      true
    else
      false
    end
  end
end