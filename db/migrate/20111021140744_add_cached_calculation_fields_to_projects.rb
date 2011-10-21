class AddCachedCalculationFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cached_total_time, :float
    add_column :projects, :cached_burned_time, :float
    add_column :projects, :cached_expected_remaining_work, :float
    add_column :projects, :cached_expected_budget, :float
    add_column :projects, :cached_external_cost, :float
    add_column :projects, :cached_expected_work, :float
    add_column :projects, :cached_internal_cost, :float
    add_column :projects, :cached_hourly_rate, :float
    add_column :projects, :cached_expected_profitability, :float
    add_column :projects, :cached_expected_return, :float
  end
end
