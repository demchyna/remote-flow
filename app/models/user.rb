class User < ApplicationRecord
  SUPER_ADMIN = 'super_admin'.freeze
  ADMIN = 'admin'.freeze
  MANAGER = 'manager'.freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :invitable

  mount_uploader :avatar, AvatarUploader

  belongs_to :organization, optional: true
  accepts_nested_attributes_for :organization
  validates :first_name, length: { maximum: 250 }, presence: true
  validates :last_name, length: { maximum: 250 }, presence: true
  validates :organization_id, presence: true, unless: :super_admin?
  validates :role, inclusion: { in: [SUPER_ADMIN, ADMIN, MANAGER] }

  scope :by_name, -> { order(:first_name) }
  scope :super_admins, -> { where(role: SUPER_ADMIN) }

  def super_admin?
    self.role == SUPER_ADMIN
  end

  def admin?
    self.role == ADMIN
  end

  def manager?
    self.role == MANAGER
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.to_csv
    attributes = %w{id email first_name last_name role organization}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      left_joins(:organization).select('users.*, organizations.name as organization_name').each do |user|
        csv << [
          user.id,
          user.first_name,
          user.last_name,
          user.email,
          user.role,
          (user.organization_name || 'N/A')
        ]
      end
    end
  end
end
