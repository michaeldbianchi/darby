require 'active_model'

module Darby
  class Portfolio
    include ::ActiveModel::Validations

    REQUIRED_ATTRIBUTES = %i[name type stocks]
    ALLOWED_ATTRIBUTES = REQUIRED_ATTRIBUTES

    validates_presence_of *REQUIRED_ATTRIBUTES
    attr_accessor *ALLOWED_ATTRIBUTES

    def initialize(params = {})
      params.each do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to?(setter.to_sym, false)
      end
      @stocks = stocks.map { |stock| AlphaVantage.client.stock(symbol: stock[:symbol])}
    end

    def to_s
      "Portfolio: #{name} - Valid: #{valid?} - Errors: #{errors.messages}"
    end

    def df
      @df ||= begin
        stock_vectors = stocks.map { |stock| { stock.symbol => stock.timeseries }}
        Daru::DataFrame.new()
      end
    end

    def timeseries_close_data
      # TODO: Identify a better format for this
      @timeseries_close_data ||= stocks.map { |stock| { stock.symbol => stock.timeseries(adjusted: true, outputsize: "full").adjusted_close.map { |data| [Date.parse(data.first), data.last] } } }
    end

    def earliest_date
      @earliest_date ||= timeseries_data.map { |timeseries| timeseries.map(&:first).min }
    end

    class << self
      def portfolios
        @portfolios ||= all_portfolios.select { |portfolio| puts portfolio; portfolio.valid? }
      end

      def all_portfolios
        @all_portfolios ||= Global.portfolios.all.flatten.map { |portfolio| new_from_config(portfolio) }
      end

      def new_from_config(config)
        if config.keys.none? { |key| ALLOWED_ATTRIBUTES.include?(key.to_sym) }
          raise "Invalid key #{key}"
        end
        Portfolio.new(config)
      end
    end
  end
end
