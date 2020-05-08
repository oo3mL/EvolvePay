# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_union_member'
require_relative '../add_hourly_employee'
require_relative '../payroll_database'

describe ChangeUnionMember do
  it 'should change an employee to have a union affiliation' do
    emp_id = 12
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 1500, database)
    t.execute

    member_id = 7743
    cut = ChangeUnionMember.new(emp_id, member_id, 99.42, database)
    cut.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    af = e.affiliation
    af.wont_be_nil
    af.dues.must_be_close_to 99.42, 0.001

    member = database.union_member(member_id)
    member.wont_be_nil
    member.must_equal e
  end
end
