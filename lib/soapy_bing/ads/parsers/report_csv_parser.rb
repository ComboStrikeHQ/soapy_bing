# frozen_string_literal: true

require 'csv'

module SoapyBing
  class Ads
    module Parsers
      class ReportCsvParser
        class FormatError < StandardError; end

        CSV_PAYLOAD_OFFSET_FRONT = 10 # First 10 csv lines are report metadata
        CSV_PAYLOAD_OFFSET_BACK = 2 # Last 2 csv lines are Microsoft copyright

        def initialize(raw)
          @raw = raw
        end

        def rows
          @rows ||= begin
            header, *body = extract_csv_payload
            raise FormatError if body.size != payload_rows_number
            body.map { |row| header.zip(row).to_h }
          end
        end

        private

        attr_reader :raw

        def extract_csv_payload
          text = raw.dup
          text.force_encoding(Encoding::UTF_8).encode! unless text.encoding == Encoding::UTF_8
          text.sub!(/^\xEF\xBB\xBF/, '') # cleanup BOM

          csv_rows = CSV.parse(text)
          csv_rows[CSV_PAYLOAD_OFFSET_FRONT...-CSV_PAYLOAD_OFFSET_BACK]
        end

        def payload_rows_number
          raw.match(/"Rows: (\d+)"/)[1].to_i
        end
      end
    end
  end
end
