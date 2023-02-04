# frozen_string_literal: true

class Dashboard::CalendarController < DashboardBaseController
  before_action -> { authorize(:calendar) }

  def index
    respond_to do |format|
      format.html
      format.json do
        render(json: {
          leaves: calendar_leaves,
          birthdays: calendar_birthdays,
        })
      end
    end
  end

  private

  def calendar_params
    params.require(:calendar).permit(:start_date, :end_date, :base_date)
  end

  def calendar_leaves
    # TODO: save to the cache if possible to avoid the same query
    leaves = Leave.select(:id, :public_id, :start_date, :end_date, :half_day, :half_day_time, :leave_type_id, :employee_id)
      .includes(:leave_type, :employee)
      .for_calendar(calendar_params[:start_date], calendar_params[:end_date])

    leaves.map do |leave|
      leave.attributes.merge({
        user: {
          name: leave.employee.name,
        },
        leave_type: {
          name: leave.leave_type.name,
        },
      }).except("id")
    end
  end

  def calendar_birthdays
    month = Date.parse(calendar_params[:base_date]).try(:month)
    employees = Employee.select(:public_id, :name, :birthday).for_birthday(month)
    employees.map { |p| { id: p.public_id, name: p.name, birthday: p.birthday } }
  end
end
