require 'rubygems'
require 'date'
require 'csv'
require 'active_model'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'


%w[version configuration helpers alphabet codes italian_citizen fiscal_code].each do |filename|
  require "codice_fiscale/#{filename}"
end


module CodiceFiscale
  def self.config
    @config ||= Configuration.new
  end

  def self.calculate params
    citizen = ItalianCitizen.new params
    raise ArgumentError.new(citizen.errors.full_messages.join(', ')) unless citizen.valid?
    citizen.fiscal_code
  end

  # This method is used by me to update the csv and repack the gem
  def self.update_csv_files(are_you_sure = false)
    unless are_you_sure
      warn("Nothing was done, call me with are_you_sure = true")
      return
    end

    require "net/http"
    require "tmpdir"
    require "tmpdir"
    require "fileutils"

    # download the CSV with all the city codes
    # @see https://www.istat.it/it/archivio/6789 for more info
    url = "https://www.istat.it/storage/codici-unita-amministrative/Elenco-comuni-italiani.csv"
    res = Net::HTTP.get_response(URI(url))
    raise("Failed to GET #{url}") unless res.is_a?(Net::HTTPSuccess)
    data = res.body

    # Covert to utf-8
    data.force_encoding("iso-8859-1")
    data.encode!("utf-8")
    raise("Failed to convert to utf-8") unless data.valid_encoding?

    # parse it and rebuild a new CSV selecting only the columns I need
    CSV.open(config.city_codes_csv_path, "wb") do |csv|
      CSV.parse(data, :col_sep => ";", :row_sep => "\r\n").each_with_index do |r, index|
        next if index == 0

        c, p, x = *[r[5], r[13], r[18]].map(&:strip)

        raise("Check the number of columns: #{r}") if r.size != 23
        raise("Invalid city name: #{c}")           if c.include?(',') or c.blank?
        raise("Invalid province code: #{p}")       if p !~ /^[A-Z]{2}$/
        raise("Invalid city code: #{x}")           if x !~ /^[A-Z]{1}[0-9]{3}$/

        csv << [c, p, x]
      end
    end

    # checkout the CSV with all the country codes
    # @see https://www.istat.it/it/archivio/6747
    url = "https://www.istat.it/it/files//2011/01/Elenco-codici-e-denominazioni-unita-territoriali-estere.zip"
    res = Net::HTTP.get_response(URI(url))
    raise("Failed to GET #{url}") unless res.is_a?(Net::HTTPSuccess)

    # store the zip in temporary folder and extract it
    tmpdir = Dir.mktmpdir
    filename = "Elenco-codici-e-denominazioni-unita-territoriali-estere"
    system("cd #{tmpdir} && unzip -q -o #{tmpdir}/#{filename}.zip")
    data = File.open(Dir["#{tmpdir}/**/*.csv"][0], "rb", &:read)

    # Covert the csv to utf-8
    data.force_encoding("iso-8859-1")
    data.encode!("utf-8")
    raise("Failed to convert to utf-8") unless data.valid_encoding?

    # parse it and rebuild a new CSV selecting only the columns I need
    CSV.open(config.country_codes_csv_path, "wb") do |csv|
      CSV.parse(data, :col_sep => ";", :row_sep => "\r\n").each_with_index do |r, index|
        next if index == 0
        next if r.compact.empty?

        c1, c2, x = *[r[6], r[7], r[9]].map(&:strip)

        next if x.casecmp('n.d.').zero?

        raise("Check the number of columns: #{r}") if r.size != 15
        raise("Invalid country name: #{c1}")       if c1.include?(',') or c1.blank?
        raise("Invalid country name: #{c2}")       if c2.include?(',') or c2.blank?
        raise("Invalid country code: #{x}")        if x !~ /^[A-Z]{1}[0-9]{3}$/

        csv << [c1, c2, x]
      end
    end
  ensure
    FileUtils.rm_rf(tmpdir) if tmpdir and Dir.exists?(tmpdir)
  end
end
