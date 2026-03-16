class CreatePipelineRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :pipeline_runs do |t|
      t.string :name
      t.string :status
      t.string :source
      t.string :external_url

      t.timestamps
    end
  end
end
