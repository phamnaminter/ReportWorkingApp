namespace :nampt do
  desc "Create backup data in database"
  task backup: :environment do
    puts "Starting get all table name in database"
    models = get_all_ins_model(get_all_table)
    puts "Starting create backup PATH if it not exist"
    create_backup_path
    puts "Starting backup data to CSV"
    models.each do |model|
      puts "Backup CSV of model: #{model.name}"
      db_to_csv model
    end
    puts "=======Backup Successfully=========="
  end

  desc "Reset database to backup point"
  task pick: :environment do
    puts "Starting reset database"
    puts "Check your backup_name is exist"
    check_exist_backup
    puts "Remove all data in database"
    remove_database
    puts "Start move database to backup"
    pick ENV.fetch("backup_name")
    puts "=======Pick Database Successfully=========="
  end

  desc "Show All backup point"
  task show: :environment do
    show_all_point
  end
end

EXCEPT = %i(ActiveStorageAttachment ActiveStorageBlob
            ArInternalMetadatum SchemaMigration).freeze

def get_all_table
  ActiveRecord::Base.connection.tables.map do |model|
    model.capitalize.singularize.camelize
  end
end

def get_all_ins_model models
  models_ins = []
  models.each do |model|
    next if EXCEPT.include? model.to_sym

    models_ins.push model.singularize.classify.constantize
  end
  models_ins
end

def db_to_csv model
  CSV.open(csv_file_path(model), "w") do |csv|
    csv << model.column_names
    model.all.each_with_index do |l, _index|
      csv << convert_record_to_arr(l)
    end
  end
end

def convert_record_to_arr active_record
  result = []
  active_record.attributes.each do |_key, value|
    result << value
  end
  result
end

def create_backup_path
  unless ENV["backup_name"]
    puts "=========Backup Failure============="
    abort("You are not defined backup name. Please provide backup name as (rake
           nampt:backup backup_name = EXAMPLE)")
  end

  Dir.mkdir("nampt") unless Dir.exist?("nampt")

  mk_dir = "nampt/".concat(ENV.fetch("backup_name"))

  if Dir.exist?(mk_dir)
    puts "=========Backup Failure============="
    abort("Your backup name: #{ENV.fetch('backup_name')} is already exists,
          Please try another backup name")
  end

  Dir.mkdir("nampt/#{ENV.fetch('backup_name')}")
end

def csv_file_path model
  "nampt/".concat(ENV.fetch("backup_name")).concat("/").concat(model.name)
          .concat(".csv")
end

def check_exist_backup
  unless ENV["backup_name"]
    puts "=========Reset Failure============="
    abort("You are not defined backup name. Please provide backup name as (rake
           nampt:reset backup_name = EXAMPLE)")
  end
  return if Dir.exist? "nampt/".concat(ENV.fetch("backup_name"))

  puts "=========Reset Failure============="
  abort("Your backup name: #{ENV.fetch('backup_name')} is not exists,
        Please try another backup name")
end

def pick backup_name
  dir = "nampt/".concat(backup_name).concat("/*")
  Dir[dir].each do |model_dir|
    model_name = model_name(model_dir, backup_name)
    puts "=============Import #{model_name}======="
    begin
      ActiveRecord::Base.connection.execute "SET FOREIGN_KEY_CHECKS=0;"
      CSV.foreach(model_dir, headers: true) do |row|
        puts "Import #{row.to_hash}"
        ins = model_name.constantize.new(row.to_hash)
        ins.save validate: false
      end
    ensure
      ActiveRecord::Base.connection.execute "SET FOREIGN_KEY_CHECKS=1;"
    end
  end
end

def model_name model_dir, backup_name
  model_dir.sub(".csv", "").sub("nampt/".concat(backup_name).concat("/"), "")
end

def remove_database
  models = get_all_ins_model(get_all_table)
  models.each do |model|
    puts "Delete record of tabler: #{model.name}"
    model.destroy_all
  end
end

def show_all_point
  points = Dir["nampt/*"]
  abort("No backup points found") if points.blank?

  points.each do |point|
    puts point.sub("nampt/", "")
  end
end
