class Room < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :groups_chats
end
