require 'csv'

class ZipParser
  attr_reader :bad_zips_by_row

  def initialize(file_name)
    file_name = file_name
    file_path = File.absolute_path file_name

    # Create an array with the zips
    rows = CSV.read(file_path)

    # from the imported csv above (called rows now)
    # select the first array and name it header_row. rows is an array of arrays.
    header_row = rows.first
    index_for_zipcode_column = index_for_zipcode(header_row)

    # Were any invalid zipcodes found?
    @bad_zips_by_row = compute_bad_zips_by_row(rows, index_for_zipcode_column)
  end

  def ready_for_prod_support?
    @bad_zips_by_row.empty?
  end

  private
    # Method to find correct column
    def index_for_zipcode(header_row)
      column_name = header_row.find {|possible_match| possible_match.downcase.gsub(/\W/, '') == "zipcode"}
      header_row.index(column_name) or raise "Could not find zip code column in header row: #{header_row.inspect}"
    end

    # Index the zips
    def zips_by_row(rows)
      zips_by_row = {}
      rows.each_with_index do |row, index|
        zips_by_row[index] = row
      end
    end

    # Tests if zips are valid or not
    def zip_valid?(zip)
      zip.match( /^\d{5}$/ )
    end

    def compute_bad_zips_by_row(rows, index_for_zipcode_column)
      # Get rid of the header row!
      bad_zips_by_row = {}
      non_header_rows(rows).each_with_index do |row, row_number|
        zipcode = row[index_for_zipcode_column]
        if !zip_valid?(zipcode)
          # Adding 2 - one for the header row and
          # one to convert from 0-based to 1-based indexing for user display
          bad_zips_by_row[row_number + 2] = zipcode
        end
      end

      bad_zips_by_row
    end

    def non_header_rows(rows)
      rows.slice(1, rows.length)
    end


end