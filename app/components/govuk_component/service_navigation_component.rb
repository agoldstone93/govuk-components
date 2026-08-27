class GovukComponent::ServiceNavigationComponent < GovukComponent::Base
  renders_one :navigation_start
  renders_one :navigation_end
  renders_one :content_before
  renders_one :content_after

  renders_one :service_name, "GovukComponent::ServiceNavigationComponent::ServiceNameComponent"
  renders_many :navigation_items, ->(text:, href: nil, current_path: nil, active_when: nil, current: false, active: false, classes: [], html_attributes: {}) do
    GovukComponent::ServiceNavigationComponent::NavigationItemComponent.new(
      text:,
      href:,
      current_path: current_path || @current_path,
      active_when:,
      current:,
      active:,
      classes:,
      html_attributes:
    )
  end

  attr_reader :aria_label_text, :navigation_id, :inverse, :inline

  def initialize(service_name: nil, service_url: nil, navigation_items: [], current_path: nil, aria_label: "Service information", navigation_id: 'navigation', inverse: false, inline: false, classes: [], html_attributes: {})
    @service_name_text = service_name
    @service_url = service_url
    @current_path = current_path
    @aria_label_text = aria_label
    @navigation_id = navigation_id
    @inverse = inverse
    @inline = inline

    if @service_name_text.present?
      with_service_name(service_name: @service_name_text, service_url:)
    end

    navigation_items.each { |ni| with_navigation_item(current_path:, **ni) }

    super(classes:, html_attributes:)
  end

  def call
    outer_element do
      safe_join(
        [
          tag.div(class: class_names("#{brand}-width-container", "#{brand}-service-navigation__inlining-container" => inline)) do
            safe_join(
              [
                content_before,
                tag.div(class: "#{brand}-service-navigation__container") do
                  safe_join([service_name, navigation].compact)
                end,
                content_after
              ]
            )
          end
        ]
      )
    end
  end

  def navigation
    return unless navigation_items?

    tag.nav(aria: { label: "Menu" }, class: "#{brand}-service-navigation__wrapper") do
      safe_join([menu_button, navigation_list])
    end
  end

  def navigation_list
    tag.ul(safe_join([navigation_start, *navigation_items, navigation_end]), id: navigation_id, class: "#{brand}-service-navigation__list")
  end

private

  def outer_element(&block)
    if service_name?
      tag.section(**aria_attributes, **html_attributes, &block)
    else
      tag.div(**html_attributes, &block)
    end
  end

  def default_attributes
    {
      class: class_names(
        "#{brand}-service-navigation",
        "#{brand}-service-navigation--inverse" => inverse,
      ),
      data: { module: "#{brand}-service-navigation" },
    }
  end

  def aria_attributes
    { aria: { label: aria_label_text } }
  end

  def menu_button
    tag.button(
      "Menu",
      type: 'button',
      class: ["#{brand}-service-navigation__toggle", "#{brand}-js-service-navigation-toggle"],
      aria: { controls: navigation_id, hidden: true },
      hidden: true
    )
  end
end
