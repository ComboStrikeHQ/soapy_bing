# frozen_string_literal: true
require 'csv'

module SoapyBing
  class Ads
    module Bulk
      module Parsers
        class CSVParser
          def initialize(raw)
            @raw = raw
          end

          def rows
            @rows ||= begin
              header, *body = extract_csv_payload
              body.map { |row| header.zip(row).to_h }
            end
          end

          private

          attr_reader :raw

          def extract_csv_payload
            text = raw.dup
            text.force_encoding(Encoding::UTF_8).encode! unless text.encoding == Encoding::UTF_8
            text.sub!(/^\xEF\xBB\xBF/, '') # cleanup BOM

            CSV.parse(text)
          end
        end
      end
    end
  end
end
