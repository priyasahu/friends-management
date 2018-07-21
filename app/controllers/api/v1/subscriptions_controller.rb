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

  def get_emails
    sender = User.find_by(email: params["sender"])
    subscribers = subscribers(sender)
    emails = check_email_validity(params["text"])[0]
    if !emails.nil?
      emails.each do |email|
        next unless !subscribers.include?(email)
        subscribers << email
      end
    end
    if subscribers.count == 0
      render json: { success: false,
                     error: 'No recipients' }, status: 400
    else
      render json: { success: true,
                     recipients: subscribers }, status: 201
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

  def subscribers(sender)
    subscribers = []
    sender.friends.each do |friend|
      next unless !friend.blocks.exists?(target_id: sender.id)
      if !subscribers.include?(friend.email)
        subscribers << friend.email
      end
    end
    sender.inverse_friends.each do |friend|
      next unless !friend.blocks.exists?(target_id: sender.id)
      if !subscribers.include?(friend.email)
        subscribers << friend.email
      end
    end
    Subscription.where(target_id: sender.id).each do |subscriber|
      next unless !subscriber.user.blocks.exists?(target_id: sender.id)
      if !subscribers.include?(subscriber.user.email)
        subscribers << subscriber.user.email
      end
    end

    subscribers
  end

  def check_email_validity(string)
    emails = []
    regex = Regexp.new(/\b[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9.-](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)\b/)
    emails << string.scan(regex)
    emails.each do |email|
      next unless !User.exists?(email: email)
      emails.delete(email)
    end
    emails
  end
end
