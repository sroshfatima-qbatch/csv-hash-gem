require 'csv'

class CreateCsv

  def self.create_csv(val, filename, mod)
    @val, @filename, @mod = val, filename, mod
    flag = check_values
    return if flag==false
    if @val.is_a?(Array)
      if @val.first.is_a?(Hash)
        array_of_hash_to_csv
      elsif @val.all? { |e| (e.kind_of? Array)}
        multi_dimentional_array_to_csv
      else
        array_to_csv
      end
    elsif @val.is_a?(Hash)
      hash_to_csv
    else
      puts "Wrong Data Structure"
    end
  end

  def self.create_hash(filename)
    @filename = filename
    csv_to_hash
  end

  private

  def self.array_to_csv
    CSV.open("#{@filename}.csv", "#{@mod}") do |csv|
      csv << @val
    end
  end

  def self.multi_dimentional_array_to_csv
    CSV.open("#{@filename}.csv", "#{@mod}") do |csv|
      @val.each { |arr| csv << arr }
    end
  end

  def self.hash_to_csv
    CSV.open("#{@filename}.csv", "#{@mod}") do |csv|
      csv << @val.keys unless @mod.include? "a"
      csv << @val.values
    end
  end

  def self.array_of_hash_to_csv
    CSV.open("#{@filename}.csv", "#{@mod}") do |csv|
    csv << @val.first.keys unless @mod.include? "a"
      @val.each do |hash|
        csv << hash.values
      end
    end
  end

  def self.csv_to_hash
    CSV.open("#{@filename}.csv", :headers =>true).map(&:to_h)
  end

  def self.check_values
    unless @mod.match /a|w/ 
      puts "Wrong File Open Mode" 
      return false
    end
    if @val.blank? 
      puts "Blank Data" 
      return false
    elsif @filename.blank?
      puts "Blank Filename" 
      return false
    end
  end

end