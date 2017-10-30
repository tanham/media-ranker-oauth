class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work
  has_many :works

  validates :username, uniqueness: true, presence: true

  def self.from_auth_hash(provider, auth_hash)
    user = new
    user.provider = provider
    user.uid = auth_hash['uid']
    user.username = auth_hash['info']['name'] || auth_hash['info']['nickname']
    user.email = auth_hash['info']['email']

    return user
  end

end
