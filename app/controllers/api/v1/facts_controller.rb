class Api::V1::FactsController < ApplicationController
  include AuthenticationCheck

  before_action :is_user_logged_in
  
  before_action :set_member, only: [:index, :show, :update, :create, :destroy]
  before_action :set_fact, only: [:show, :update, :destroy]
  before_action :check_access, only: [:show, :update, :destroy]

  # skip_before_action :verify_authenticity_token
  


  # GET /members/:member_id/facts
  def index
    render json: { facts: @member.facts }, status: 200 # note that because the facts route is nested inside members
    # we return only the facts belonging to that member
  end

  # GET /members/:member_id/facts/:id
  def show
    @member= Member.find_by(id: params[:member_id])
    # your code goes here
      # your code goes here
    if @fact
      render json: { fact: @fact }, status: 200
    else
      render json: { error: "Fact Not Found" }, status: :not_found
    end
  end


  # POST /members/:member_id/facts
  def create
  
    @fact = @member.facts.new(fact_params)
    if @fact.save
      render json: @fact, status: 201
    else
      render json: { error: 
"The fact entry could not be created. #{@fact.errors.full_messages.to_sentence}"},
      status: 400
    end
  end

  # PUT /members/:member_id/facts/:id
  def update
    # your code goes here
      # your code goes here
    if @fact.update(fact_params)
      render json: {message: "Fact record updated successfully."}, status: 200
    else
      render json: {error: "Unable to update fact: #{@fact.errors.full_messages.to_sentence}"}, status: 400
    end   
  end

  # DELETE /members/:member_id/facts/:id
  def destroy
    # your code goes here
    if @fact
      if @fact.destroy
        render json: { message: 'Fact record successfully deleted.'}, status: 200
      else
        render json: { message: 'Fact could not be deleted.'}, status: 400
      end
    else
      render json: { error: 'Fact not found'}, status: :not_found
    end
  end

  private

  
  def fact_params
    params.require(:fact).permit(:fact_text, :likes)
  end

  def set_fact
    Rails.logger.debug("Fact ID: #{params[:id]}, Member ID: #{params[:member_id]}")
    @fact = Fact.find_by(id: params[:id], member_id: params[:member_id])
    render json: { error: "Fact not found" }, status: :not_found unless @fact
  end
  
  def set_member
    
    @member = Member.find_by(id: params[:member_id])
    
  end

  def check_access
    if (@member.user_id != current_user.id) 
      render json: { message: "The current user is not authorized for that data."}, status: :unauthorized
      return false
    end
    true
  end
end
