require 'csv'

class CreateCsv

  def self.create_csv(val, filename, mod, key_values = nil)
    @val, @filename, @mod = val, filename, mod
    @key_values = key_values unless key_values.nil?
    flag = check_values
    return if flag==false
    if @val.is_a?(Array)
      if @val.first.is_a?(Hash)
        unless key_values.nil?
          hash_to_csv_keys
        else
          array_of_hash_to_csv
        end
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

  def self.create_hash(filename, check = nil)
    @filename = filename
    @check = check unless check.blank?
    if check.blank?
      csv_to_hash
    elsif @check == true
      csv_to_hash_without_nil
    end
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
    CSV.open("#{@filename}.csv", "#{@mod}", headers: true) do |csv|
      csv << @val.keys unless @mod.include? "a"
      csv << @val.values
    end
  end

  def self.hash_to_csv_keys
    keys = @val.flat_map(&:keys).uniq
    keys = @key_values if @key_values.all?{|w| keys.include?(w)}
    CSV.open("#{@filename}.csv", "#{@mod}") do |csv|
      csv << keys unless @mod.include? "a"
      @val.each do |hash|
        csv << hash.values_at(*keys)
      end
    end
  end

  def self.array_of_hash_to_csv
    keys = @val.flat_map(&:keys).uniq
    CSV.open("#{@filename}.csv", "#{@mod}") do |csv|
      csv << keys unless @mod.include? "a"
      @val.each do |hash|
        csv << hash.values_at(*keys)
      end
    end
  end

  def self.csv_to_hash
    CSV.open("#{@filename}.csv", :headers =>true).map(&:to_h)
  end

  def self.csv_to_hash_without_nil
    h1 = Hash.new
    h2 = []
    csv = CSV.read("#{@filename}.csv", :headers =>true)
    key = csv.headers
    csv.each do |w|
      key.zip(w).each do |i,j|
        next if j[1].blank?
        h1[i]=j[1]
      end
      h2.push(h1)
      h1 ={}
    end
    h2
  end

  def self.check_values
    unless @mod.match /a|w/ 
      puts "Wrong File Open Mode" 
      return false
    end
    unless @key_values.is_a?(Array)
      puts "Keys must be in an array format" 
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