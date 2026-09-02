module Examples
  module ServiceNavigationHelpers
    def service_navigation_with_only_service_name
      <<~SNIPPET
        = govuk_service_navigation(service_name: "My new service", service_url: "#")
      SNIPPET
    end

    def service_navigation_with_a_current_page
      <<~SNIPPET
        = govuk_service_navigation(service_name: "My new service",
                                   navigation_items: navigation_items,
                                   navigation_id: 'example-2')
      SNIPPET
    end

    def service_navigation_with_a_current_page_data
      <<~DATA
        { navigation_items: [
          { text: "Footer",   href: "/components/footer" },
          { text: "Header",   href: "/components/header", current: true },
          { text: "Panel", href: "/components/panel" },
          { text: "Table", href: "/components/table" },
          { text: "Tag",  href: "/components/tag" }
        ] }
      DATA
    end

    def service_navigation_with_navigation_items
      <<~SNIPPET
        = govuk_service_navigation(service_name: "My new service",
                                   current_path: "/components/panel",
                                   navigation_items: navigation_items,
                                   navigation_id: 'example-3')
      SNIPPET
    end

    def service_navigation_with_navigation_items_data
      <<~DATA
        { navigation_items: [
          { text: "Footer",   href: "/components/footer" },
          { text: "Header",   href: "/components/header" },
          { text: "Panel", href: "/components/panel" },
          { text: "Table",  href: "/components/table" },
          { text: "Tag",  href: "/components/tag" }
        ] }
      DATA
    end

    def service_navigation_with_matching_subpages
      <<~SNIPPET
        = govuk_service_navigation(service_name: "My new service",
                                   current_path: "/components/table/dining/extendable",
                                   navigation_items: navigation_items,
                                   navigation_id: 'example-4')
      SNIPPET
    end

    def service_navigation_with_matching_subpages_data
      <<~DATA
        { navigation_items: [
          { text: "Footer",   href: "/components/footer", active_when: "/components/footer" },
          { text: "Header",   href: "/components/header", active_when: "/components/header" },
          { text: "Panel", href: "/components/panel", active_when: "/components/panel" },
          { text: "Table",  href: "/components/table", active_when: "/components/table" },
          { text: "Tag",  href: "/components/tag", active_when: "/components/tag" }
        ] }
      DATA
    end

    def service_navigation_manual_start_end_nav
      <<~SNIPPET
        = govuk_service_navigation(navigation_id: 'example-5') do |sn|
          - sn.with_navigation_start { tag.li('🌅', class: 'govuk-service-navigation__item') }
          - sn.with_service_name(service_name: 'A really great service', service_url: '#')
          - sn.with_navigation_item(text: "Footer", href: "/components/footer")
          - sn.with_navigation_item(text: "Header", href: "/components/header")
          - sn.with_navigation_item(text: "Panel", href: "/components/panel")
          - sn.with_navigation_item(text: "Table", href: "/components/table")
          - sn.with_navigation_item(text: "Tag", href: "/components/tag", active: true)
          - sn.with_navigation_end { tag.li('🌆', class: 'govuk-service-navigation__item') }
      SNIPPET
    end

    def service_navigation_manual_content_above_below
      <<~SNIPPET
        = govuk_service_navigation(navigation_id: 'example-6') do |sn|
          - sn.with_content_before { tag.p('Content above') }
          - sn.with_service_name(service_name: 'A really great service', service_url: '#')
          - sn.with_navigation_item(text: "Footer", href: "/components/footer")
          - sn.with_navigation_item(text: "Header", href: "/components/header")
          - sn.with_content_after { tag.p('Content below') }
      SNIPPET
    end

    def service_navigation_manual_content_inline
      <<~SNIPPET
        = govuk_service_navigation(navigation_id: 'example-7', inline: true) do |sn|
          - sn.with_service_name(service_name: 'A really great service', service_url: '#')
          - sn.with_navigation_item(text: "Footer", href: "/components/footer")
          - sn.with_navigation_item(text: "Header", href: "/components/header")
          - sn.with_content_after { govuk_language_navigation(items:) }
      SNIPPET
    end

    def service_navigation_manual_content_inline_data
      <<~DATA
        {
          items: [
            { text: 'English', lang: 'en', href: '#/en', current: true },
            { text: "Українська", lang: "uk", href: "#/uk" },
            { text: "Polski", lang: "pl", href: "#/pl" }
          ]
        }
      DATA
    end

    def service_navigation_with_inverted_colours
      <<~SNIPPET
        = govuk_service_navigation(inverse: true,
                                   service_name: 'An inverted service',
                                   navigation_items: navigation_items,
                                   current_path: "/components/header")
      SNIPPET
    end
  end
end
