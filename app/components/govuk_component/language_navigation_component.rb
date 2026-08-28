class GovukComponent::LanguageNavigationComponent < GovukComponent::Base
  attr_reader :inverse, :any_rtl

  renders_many :items, "GovukComponent::LanguageNavigationComponent::Item"

  def initialize(items: [], inverse: false, classes: [], html_attributes: {})
    @items = items
    @any_rtl = items.any? { |item| item.symbolize_keys[:dir] == 'rtl' }
    @inverse = inverse

    super(classes:, html_attributes:)
  end

  def before_render
    @items.each { |item| with_item(**item, any_rtl:) }
  end

  def call
    tag.nav(**html_attributes) do
      tag.ul(class: "#{brand}-language-navigation__list") do
        safe_join(items)
      end
    end
  end

  def render?
    items.any?
  end

  def default_attributes
    {
      class: class_names(
        "#{brand}-language-navigation",
        "#{brand}-language-navigation--inverse" => inverse
      ),
      aria: { label: 'language' }
    }
  end

  class GovukComponent::LanguageNavigationComponent::Item < GovukComponent::Base
    include GovukVisuallyHiddenHelper

    attr_reader :text, :lang, :current, :href, :href_lang, :language_description_text, :any_rtl, :dir

    def initialize(text:, lang:, href: nil, language_description_text: nil, current: false, href_lang: nil, dir: 'ltr', any_rtl: false, classes: [], html_attributes: {})
      @text = text
      @lang = lang
      @href = href
      @href_lang = href_lang || lang
      @current = current
      @language_description_text = language_description_text
      @dir = dir if any_rtl

      super(classes:, html_attributes:)
    end

    def call
      tag.li(content, **default_attributes)
    end

  private

    def content
      common = { dir: dir, lang: lang }

      if current
        tag.span(
          text,
          class: "#{brand}-language-navigation__text",
          aria: { current: true },
          **common
        )
      else
        link_text = if language_description_text.present?
                      text + govuk_visually_hidden(' ' + language_description_text)
                    else
                      text
                    end
        tag.a(
          link_text,
          class: "#{brand}-language-navigation__link",
          href:,
          lang: lang,
          hreflang: href_lang,
          rel: 'alternate',
          **common
        )
      end
    end

    def default_attributes
      { class: "#{brand}-language-navigation__list-item" }
    end
  end
end
