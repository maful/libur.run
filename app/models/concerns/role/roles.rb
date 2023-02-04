# frozen_string_literal: true

module Role::Roles
  ROLE_ADMIN = "admin"
  ROLE_USER = "user"
  ROLE_EXECUTIVE = "executive"
  ROLE_MANAGER = "manager"
  ROLE_EMPLOYEE = "employee"

  ORIGINAL_ROLES = [ROLE_ADMIN, ROLE_USER, ROLE_EXECUTIVE, ROLE_MANAGER, ROLE_EMPLOYEE]
  UNPUBLISHED_ROLES = [ROLE_ADMIN, ROLE_USER]
end
