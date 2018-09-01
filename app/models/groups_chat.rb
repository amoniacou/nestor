class GroupsChat < ApplicationRecord
  belongs_to :room, optional: true
  validates :service, :service_id, presence: true
end
