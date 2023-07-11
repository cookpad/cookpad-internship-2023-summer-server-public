require 'csv'

def insert_all(model_class, csv_path)
  if defined? model_class
    records = CSV.read(csv_path, headers: true).map(&:to_hash)
    records = records.map { |r| r.slice(*model_class.column_names) }
    model_class.insert_all(records)
  end
end

insert_all(Hashtag, "#{File.dirname(__FILE__)}/seeds/hashtags.csv") if defined? Hashtag
