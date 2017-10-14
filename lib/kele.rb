require 'json'
require 'httparty'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  checkpoint_id=1619
  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: {"email": email, "password": password})
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body, symbolize_names: true)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body, symbolize_names: true)
  end

  def get_messages(page_number = nil)
    if page_number == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads?page=#{page_number}"), headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body, symbolize_names: true)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post(api_url("messages"), body: {"sender": sender, recipient_id: recipient_id, "token": token, "subject": subject, "stripped-text": stripped_text}, headers: { "authorization" => @auth_token, "content_type" => application/json})
    @message = JSON.parse(response.body)
  end

  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
