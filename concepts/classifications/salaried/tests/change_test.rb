# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Salaried::Operations::Change do
  include DatabaseCleanerSupport

  it 'should an employees payment classifications to salaried' do
    id = 10
    database =  Relational::PostgresqlDatabase.new
    operation = Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database)
    operation.execute

    operation = Classifications::Salaried::Operations::Change.new(id: id, salary: 1500.0, database: database)
    operation.execute

    employee = database.employee(id)
    employee.wont_be_nil

    pay_check = employee.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of Classifications::Salaried::Classification
    pay_check.salary.must_be_close_to 1500.0, 0.001

    payment_schedule = employee.schedule
    payment_schedule.must_be_kind_of Schedules::Monthly
  end
  # TODO:
  # check if the new classification will processed in the next cycle only
end
