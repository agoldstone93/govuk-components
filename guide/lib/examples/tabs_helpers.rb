module Examples
  module TabsHelpers
    def tabs_normal
      <<~TABS
        = govuk_tabs(title: "Monday’s child nursery rhyme") do |c|
          - c.with_tab(label: "Monday", text: "Monday’s child is fair of face")
          - c.with_tab(label: "Tuesday", text: "Tuesday’s child is full of grace")
          - c.with_tab(label: "Wednesday")
            | Wednesday’s child is full of woe
      TABS
    end
  end
end
