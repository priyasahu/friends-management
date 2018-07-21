class Api::V1::BlocksController < ApplicationController
  before_action :set_users, only: [:create]

  def create
    if @requestor.blocks.where(target_id: @target.id).empty?
      block = @requestor.blocks.build(target_id: @target.id)
      if block.save
        subscription = @requestor.subscriptions.where(target_id: @target.id)
        if !subscription.empty?
          subscription[0].destroy
        end
        render json: { success: true }
      else
        render json: { error: 'Failed to block the user' }
      end
    else
      render json: { error: 'User has already blocked' }
    end
  end

  private

  def set_users
    if params['requestor'] == params['target']
      render json: { error: 'Can not block yourself' }
    elsif User.find_by(email: params['requestor']).nil? ||
      User.find_by(email: params['target']).nil?
      render json: {
               error: 'One of the users does not exist '
             }
    else
      @requestor = User.find_by(email: params['requestor'])
      @target = User.find_by(email: params['target'])
    end
  end
end