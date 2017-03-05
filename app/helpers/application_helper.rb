module ApplicationHelper
  def new_relationship_and_not_self?(another_user_id)
    current_user.id != another_user_id && current_user.new_relationship?(another_user_id)
  end
end
