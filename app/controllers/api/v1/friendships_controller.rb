class Api::V1::FriendshipsController < ApplicationController
  def create
    user1 = User.find_by(email: params['friends'][0])
    user2 = User.find_by(email: params['friends'][1])
    if !friendship_exists?(user1, user2) && !blocked?(user1, user2)
      friendship = user1.friendships.build(friend_id: user2.id)
      if friendship.save
        render json: { success: true }
      else
        render json: { error: 'Failed to add as friend' }
      end
    elsif blocked?(user1, user2)
      render json: { error: 'Users blocked each other'}
    else
      render json: { error: 'Users are already friends' }
    end

  end

  def show
    if (user = User.find_by(email: params['email'])).nil?
      render json: { success: false,
                     error: 'No such user'}
    else
      friends = []
      user.friends.each { |friend| friends << friend.email }
      user.inverse_friends.each { |friend| friends << friend.email }
      render json: { success: true, friends: friends,
                     count: friends.count },
             status: 200
    end
  end

  def common
    first_user_friends = []
    second_user_friends = []

    first_user = User.find_by(email: params['friends'][0])
    second_user = User.find_by(email: params['friends'][1])

    first_user.friends.each { |friend| first_user_friends << friend.email }
    first_user.inverse_friends.each { |friend| first_user_friends << friend.email }

    second_user.friends.each { |friend| second_user_friends << friend.email }
    second_user.inverse_friends.each { |friend| second_user_friends << friend.email }

    common = first_user_friends & second_user_friends
    render json: { success: true, friends: common, count: common.count }
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

  def blocked?(user1, user2)
    if user1.blocks.exists?(target_id: user2.id) ||
      user2.blocks.exists?(target_id: user1.id)
      true
    else
      false
    end
  end
end