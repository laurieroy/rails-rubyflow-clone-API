class AccessTokenSerializer
  include JSONAPI::Serializer
  attributes :id, :token
  # belongs_to :user
end
