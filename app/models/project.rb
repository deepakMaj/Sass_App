class Project < ApplicationRecord
  belongs_to :tenant
  has_many :artifacts, dependent: :destroy
  validates_uniqueness_of :title
  validate :free_plan_can_have_only_one_project

  def free_plan_can_have_only_one_project
    if self.new_record? && (tenant.projects.count > 0) && (tenant.plan == 'free')
      errors.add(:base, "Free plans cannot have more than one project")
    end
  end

  def self.by_user_plan_and_tenant(tenant_id, current_user)
    tenant = Tenant.find(tenant_id)
    if tenant.plan == 'premium'
      tenant.projects
    else
      tenant.projects.order(:id).limit(1)
    end
  end

end
