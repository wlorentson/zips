require './zip_parser'

describe "Parsing zipcodes" do

  context "Public interface" do

    context "Ready for prod support" do

      it "should pass a file with good zip codes" do
        expect(ZipParser.new('test_csvs/good.csv').ready_for_prod_support?).to eq(true)
      end

      it "should flunk a file with bad zip codes" do
        expect(ZipParser.new('test_csvs/bad.csv').ready_for_prod_support?).to eq(false)
      end

    end

    context "Identifying rows with bad zip codes" do

      it "should give a list of bad rows with zips" do
        zip_parser = ZipParser.new('test_csvs/bad.csv')
        expected_bad_rows = {
          3 => "badzip",
          5 => "123456"
        }
        expect(zip_parser.bad_zips_by_row).to eq(expected_bad_rows)
      end

    end

  end

end