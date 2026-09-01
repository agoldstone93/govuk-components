module Examples
  module LanguageNavigationHelpers
    def language_navigation_basic
      <<~BASIC
        = govuk_language_navigation(items: items)
      BASIC
    end

    def language_navigation_basic_data
      <<~BASIC_DATA
        {
          items: [
            { text: 'English', lang: 'en', current: true },
            { text: 'Français', lang: 'fr', href: '#/fr' },
            { text: 'Deutsch', lang: 'de', href: '#/de' },
            { text: '日本語', lang: 'ja', href: '#/ja' }
          ]
        }
      BASIC_DATA
    end

    def language_navigation_rtl
      <<~RTL
        = govuk_language_navigation(items: items)
      RTL
    end

    def language_navigation_rtl_data
      <<~RTL_DATA
        {
          items: [
            { text: 'English', lang: 'en', current: true },
            { text: '日本語', lang: 'ja', href: '#/ja' },
            { text: 'العربية', lang: 'ar', href: '#/ar', dir: 'rtl' }
          ]
        }
      RTL_DATA
    end

    def language_navigation_manual
      <<~MANUAL
        = govuk_language_navigation(html_attributes: { lang: "en" }) do |c|
          = c.with_item(text: "English", current: true, lang: "en")
          = c.with_item(text: "Cymraeg", lang: "cy", href: "#/cy", language_description_text: "Newid yr iaith i'r Cymraeg")
      MANUAL
    end

    def language_navigation_inverse
      <<~BASIC
        = govuk_language_navigation(items: items, inverse: true)
      BASIC
    end
  end
end
