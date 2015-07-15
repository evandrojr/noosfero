class EmailTemplate < ActiveRecord::Base

  belongs_to :owner, :polymorphic => true

  attr_accessible :template_type, :subject, :body, :owner, :name

  validates_presence_of :name

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
      :organization_members => {:description => _('Organization Members')}
    })
  end

  protected

  def parse(source, params)
    template = Liquid::Template.parse(source)
    template.render(HashWithIndifferentAccess.new(params))
  end

end
