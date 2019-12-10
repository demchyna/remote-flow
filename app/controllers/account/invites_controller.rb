class Account::InvitesController < Account::AccountController
  before_action :authenticate_admin_only

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.sender_id = current_user.id
    @invite.organization_id = current_organization.id

    if @invite.save
      @invite.send_invite_email(
        new_user_registration_url(invite_token: @invite.token)
      )

      flash[:success] = 'Invite sent to a user.'
      redirect_to account_path
    else
      flash[:danger] = 'Failed to send invite.'
      render :new
    end
  end

  private

  def invite_params
    params[:invite][:role] = '' if params[:invite][:role] == User::SUPER_ADMIN

    params.require(:invite).permit(:email, :role)
  end

  def authenticate_admin_only
    flash[:danger] = 'Only organization administrator can invite new users.'
    redirect_to account_path if current_user.super_admin?
  end
end
