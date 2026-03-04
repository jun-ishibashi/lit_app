# frozen_string_literal: true

class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to contact_path, notice: "お問い合わせを受け付けました。内容を確認のうえ、ご連絡いたします。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :subject, :message)
  end
end
