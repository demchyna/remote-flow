class Account::MyOrganizationController < Account::AccountController
  before_action :require_admin_only!

  def show
    @organization = resource
  end

  def edit
    @organization = resource
  end

  def update
    @organization = resource
    if resource.update(organization_params)
      flash[:success] = 'Organization updated successfully!'
      redirect_to account_my_organization_path
    else
      flash[:error] = 'Failed to update organization'
      render :edit
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :logo, :logo_cache, :remove_logo)
  end

  def resource
    current_organization
  end
end
