class CategoryBalanceNotifier

  def initialize
    @services ||= []
    discover_services
  end

  def notify(category_name, category_balance)
    @services.each do |service|
      service.notify(category_name, formatted_balance(category_balance))
    end
  end

  private

  # @todo How do we support currencys? May need to call YNAB api and get settings if possible
  def formatted_balance(category_balance)
    "£#{(category_balance/1000.to_f).round(2)}"
  end

  def add_service(service_class, config = {})
    @services << service_class.new(config)
  end

  def discover_services
    # Pushbullet
    if ENV['PUSHBULLET_API_KEY'].present?
      add_service(CategoryBalanceNotifier::Pushbullet, {
        api_key: ENV['PUSHBULLET_API_KEY']
      })
    end

    # @todo email
    # @todo sms
  end
end
