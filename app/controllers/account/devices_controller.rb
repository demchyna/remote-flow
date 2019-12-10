class Account::DevicesController < Account::AccountController
  def index
    @devices = collection.by_name.page(params[:page]).per(10)
  end

  def show
    @device = resource
  end

  def new
    @device = Device.new
  end

  def edit
    @device = resource
  end

  def create
    @device = Device.new(device_params)
    @device.organization = current_organization
    if @device.save
      flash[:success] = 'Device successfully created.'
      redirect_to account_device_path(@device)
    else
      flash[:danger] = 'Failed to create device.'
      render 'new'
    end
  end

  def update
    @device = resource
    if @device.update(device_params)
      flash[:success] = 'Device updated'
      redirect_to account_device_path(@device)
    else
      flash[:danger] = 'Error updating device'
      render :edit
    end
  end

  def destroy
    @device = resource
    if @device.destroy
      flash[:success] = 'Device successfully deleted.'
    else
      flash[:danger] = 'Failed to delete device.'
    end
    redirect_to account_devices_path
  end

  private

  def device_params
    params.require(:device).permit(:name)
  end

  def collection
    current_organization.devices
  end

  def resource
    collection.find(params[:id])
  end
end