require 'spec_helper'

TestLanguage = Struct.new(:text, :lang, :href, :language_description_text, :current, :href_lang, :dir, keyword_init: true) do
  def to_h
    super.compact
  end
end

describe(GovukComponent::LanguageNavigationComponent, type: :component) do
  let(:component_css_class) { 'govuk-language-navigation' }

  let(:german) { TestLanguage.new(text: 'Deutsch', lang: 'de', href: '/de', current: true) }
  let(:french) { TestLanguage.new(text: 'Français', lang: 'fr', href: '/fr') }
  let(:english) { TestLanguage.new(text: 'English', lang: 'en', href: '/en', dir: 'auto') }
  let(:arabic) { TestLanguage.new(text: 'العربية', lang: 'ar', href: '/ar', href_lang: 'ar', dir: 'rtl') }

  let(:items) { [german, french] }

  let(:kwargs) { { items: items.map(&:to_h) } }

  subject! { render_inline(GovukComponent::LanguageNavigationComponent.new(**kwargs)) }

  it_behaves_like 'a component that accepts custom classes'
  it_behaves_like 'a component that accepts custom HTML attributes'
  it_behaves_like 'a component that supports custom branding'
  it_behaves_like 'a component that supports brand overrides'

  specify 'renders a nav element with the right classes and aria attributes' do
    expect(rendered_content).to have_tag('nav', with: { class: component_css_class, 'aria-label' => 'language' })
  end

  context 'when colours are inverted' do
    let(:kwargs) { { items: items.map(&:to_h), inverse: true } }

    specify 'the inverse class is added' do
      expect(rendered_content).to have_tag('nav', with: { class: [component_css_class, component_css_class + '--inverse'] })
    end
  end

  specify 'renders a list entry for each item' do
    expect(rendered_content).to have_tag('li', count: 2)
  end

  specify 'the current item span is present' do
    expect(rendered_content).to have_tag('nav', with: { class: component_css_class, 'aria-label' => 'language' }) do
      with_tag('ul', with: { class: 'govuk-language-navigation__list' }) do
        with_tag('li', with: { class: 'govuk-language-navigation__list-item' }) do
          with_tag('span', with: { class: 'govuk-language-navigation__text', 'aria-current' => true }, text: german.text)
        end
      end
    end
  end

  specify 'the non-current item link is present' do
    expect(rendered_content).to have_tag('nav', with: { class: component_css_class, 'aria-label' => 'language' }) do
      with_tag('ul', with: { class: 'govuk-language-navigation__list' }) do
        with_tag('li', with: { class: 'govuk-language-navigation__list-item' }) do
          with_tag('a', with: { class: 'govuk-language-navigation__link', rel: 'alternate', lang: french.lang, hreflang: french.lang }, text: french.text)
        end
      end
    end
  end

  specify 'the non-current item has all the right attributes' do
    expect(rendered_content).to have_tag('li') do
      with_tag(
        'a',
        text: french.text,
        with: {
          class: 'govuk-language-navigation__link',
          href: french.href,
        },
      )
    end
  end

  context 'when there are no items' do
    let(:items) { [] }

    specify 'does not render' do
      expect(rendered_content).to be_blank
    end
  end

  context 'adding items one at a time' do
    subject! do
      render_inline(GovukComponent::LanguageNavigationComponent.new(**kwargs)) do |component|
        component.with_item(text: 'Italiano', lang: 'it', current: true)
        component.with_item(text: 'Lietuvių', lang: 'lt', href: '#/lt')
      end
    end

    specify "the language navigation is rendered with the supplied languages" do
      expect(rendered_content).to have_tag('nav', with: { class: component_css_class }) do
        with_tag('ul', with: { class: 'govuk-language-navigation__list' }) do
          with_tag('li > span', with: { lang: 'it' }, text: 'Italiano')
          with_tag('li > a', with: { lang: 'lt', rel: 'alternate' }, text: 'Lietuvių')
        end
      end
    end
  end

  context 'when language description text is present' do
    let(:german) { TestLanguage.new(text: 'Deutsch', lang: 'de', href: '/de', language_description_text: 'Sprache auf Deutsch ändern', current: true) }
    let(:french) { TestLanguage.new(text: 'Français', lang: 'fr', href: '/fr', language_description_text: 'Changez la langue en français') }
    let(:english) { TestLanguage.new(text: 'English', lang: 'en', href: '/en', language_description_text: 'Change language to English') }

    specify 'the text is not added to the current item' do
      text = html.css('nav > ul > li > *[lang="de"]').text

      expect(text).to eql(german.text)
    end

    specify 'the text is visually hidden and appended (with a space) to non-current items' do
      text = html.css('nav > ul > li > *[lang="fr"]').text

      expect(text).to eql(%(#{french.text}<span class="govuk-visually-hidden"> #{french.language_description_text}</span>))
    end
  end

  context 'when lang and hreflang differ' do
    let(:french) { TestLanguage.new(text: 'Français canadien', lang: 'fr', href_lang: "fr-CA", href: '/fr-ca') }

    specify 'the lang and hreflang attributes are set correctly' do
      expect(rendered_content).to have_tag('nav', with: { class: component_css_class, 'aria-label' => 'language' }) do
        with_tag('ul', with: { class: 'govuk-language-navigation__list' }) do
          with_tag('li', with: { class: 'govuk-language-navigation__list-item' }) do
            with_tag('a', with: { class: 'govuk-language-navigation__link', rel: 'alternate', lang: french.lang, hreflang: french.href_lang }, text: french.text)
          end
        end
      end
    end
  end

  context 'when an RTL language is present' do
    let(:items) { [german, french, arabic, english] }

    specify 'arabic is present and has dir="rtl"' do
      expect(rendered_content).to have_tag('nav > ul > li > a', text: arabic.text, with: { rel: 'alternate' })
    end

    specify 'the current language has dir="ltr"' do
      expect(rendered_content).to have_tag('nav > ul > li > span', text: german.text, with: { dir: 'ltr' })
    end

    specify 'all the other available languages are dir="ltr"' do
      { french.text => 'ltr', english.text => 'auto' }.each do |lang, dir|
        expect(rendered_content).to have_tag('nav > ul > li > a', text: lang, with: { dir: dir, rel: 'alternate' })
      end
    end
  end
end
