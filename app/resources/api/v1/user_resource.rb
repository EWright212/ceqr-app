module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :created_at, :updated_at

      has_many :project_permissions

      filter :email
    end
  end
end