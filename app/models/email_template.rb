class EmailTemplate < ActiveRecord::Base

  belongs_to :owner, :polymorphic => true

  attr_accessible :template_type, :subject, :body, :owner, :name

  validates_presence_of :name

  validates :name, uniqueness: { scope: [:owner_type, :owner_id] }

  validates :template_type, uniqueness: { scope: [:owner_type, :owner_id] }, if: :unique_by_type?

  def parsed_body(params)
    @parsed_body ||= parse(body, params)
  end

  def parsed_subject(params)
    @parsed_subject ||= parse(subject, params)
  end

  def available_types
    HashWithIndifferentAccess.new ({
      :task_rejection => {:description => _('Task Rejection')},
      :task_acceptance => {:description => _('Task Acceptance')},
      :organization_members => {:description => _('Organization Members')},
      :user_activation => {:description => _('User Activation'), :unique => true}
    })
  end

  def unique_by_type?
    available_types.fetch(template_type, {})[:unique]
  end

  protected

  def parse(source, params)
    template = Liquid::Template.parse(source)
    template.render(HashWithIndifferentAccess.new(params))
  end

end
