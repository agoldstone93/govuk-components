module Examples
  module BackLinkHelpers
    def back_link_normal
      <<~BACK_LINK_NORMAL
        = govuk_back_link(href: "/")
      BACK_LINK_NORMAL
    end

    def back_link_custom
      <<~BACK_LINK_NORMAL
        = govuk_back_link(href: "/", text: "Return")
      BACK_LINK_NORMAL
    end

    def back_link_inverse
      <<~BACK_LINK_INVERSE
        = govuk_back_link(href: "/", inverse: true)
      BACK_LINK_INVERSE
    end
  end
end
