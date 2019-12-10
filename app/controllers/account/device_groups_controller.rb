class Account::DeviceGroupsController < Account::AccountController
  def index
    @device_groups = collection.by_name.page(params[:page]).per(10)
  end

  def show
    @device_group = resource
    respond_to do |format|
      format.html { redirect_to account_device_groups_path }
      format.js
    end
  end

  def new
    @device_group = DeviceGroup.new
    respond_to do |format|
      format.html { redirect_to account_device_groups_path }
      format.js
    end
  end

  def create
    @device_group = DeviceGroup.new(device_group_params)
    @device_group.organization = current_organization
      if @device_group.save
        flash[:success] = 'Device group succcessfully created.'
      else
        flash[:danger] = 'Failed to create device group.'
      end
  end

  def edit
    @device_group = resource
    respond_to do |format|
      format.html { redirect_to account_device_groups_path }
      format.js
    end
  end

  def update
    @device_group = resource
      if @device_group.update(device_group_params)
        flash[:success] = 'Device group updated'
      else
        flash[:danger] = "Error updating device group."
      end
  end

  def destroy
    if resource.destroy
      flash[:success] = 'Device group successfilly deleted.'
    else
      flash[:danger] = 'Failed to delete device group.'
    end
  end

  private

  def device_group_params
    params.require(:device_group).permit(:name, :description)
  end

  def collection
    current_organization.device_groups
  end

  def resource
    collection.find(params[:id])
  end
end
