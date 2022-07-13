class CreateNotifyOnLineItemsTrigger < ActiveRecord::Migration[6.0]
  TABLE_NAME = 'line_items'.freeze
  NOTIFICATION_NAME = 'line_item'.freeze
  TABLE_MODULE = 'module'.freeze

  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION notify_#{TABLE_MODULE}_listeners() RETURNS trigger AS $trigger$
      DECLARE
        rec RECORD;
        dat RECORD;
        payload TEXT;
      BEGIN
      -- Set record row depending on operation
      CASE TG_OP
      WHEN 'UPDATE' THEN
        rec := NEW;
        dat := OLD;
      WHEN 'INSERT' THEN
        rec := NEW;
      WHEN 'DELETE' THEN
        rec := OLD;
      ELSE
        RAISE EXCEPTION 'Unknown TG_OP: "%". Should not occur!', TG_OP;
      END CASE;

      -- Build the payload
      payload := json_build_object('timestamp',CURRENT_TIMESTAMP,'action',LOWER(TG_OP),'schema',TG_TABLE_SCHEMA,'identity',TG_TABLE_NAME,'record',row_to_json(rec), 'old',row_to_json(dat));

        PERFORM pg_notify('#{NOTIFICATION_NAME}', payload);
        RETURN rec;
      END;
      $trigger$ LANGUAGE plpgsql
    SQL

    execute <<-SQL
      CREATE TRIGGER #{TABLE_MODULE}_trigger
      AFTER INSERT OR UPDATE OR DELETE
      ON #{TABLE_NAME}
      FOR EACH ROW
      EXECUTE PROCEDURE notify_#{TABLE_MODULE}_listeners()
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION notify_#{TABLE_MODULE}_listeners() CASCADE
    SQL
  end
end
