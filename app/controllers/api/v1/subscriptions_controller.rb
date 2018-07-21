class Api::V1::SubscriptionsController < ApplicationController
  before_action :assign_users, only: [:create]

  def create
    if @requestor.subscriptions.where(target_id: @target.id).empty? && !blocked?(@requestor, @target)
      subscription = @requestor.subscriptions.build(target_id: @target.id)
      if subscription.save
        render json: { success: true }
      else
        render json: { error: 'Failed to add subscription' }
      end
    elsif blocked?(@requestor, @target)
      render json: { error: 'Can not subscribe since one user has blocked the other' }
    else
      render json: { error: 'Subscription already exists' }
    end
  end

  private

  def assign_users
    if params['requestor'] == params['target']
      render json: { error: 'Cannot subscribe to yourself' }
    elsif User.find_by(email: params['requestor']).nil? ||
      User.find_by(email: params['target']).nil?
      render json: {
               error: 'One of the users does not exist'
             }
    else
      @requestor = User.find_by(email: params['requestor'])
      @target = User.find_by(email: params['target'])
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