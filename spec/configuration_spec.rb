# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveLinkTo::Configuration do
  let(:config) { ActiveLinkTo::Configuration.new }

  after do
    ActiveLinkTo.configuration = ActiveLinkTo::Configuration.new
  end

  describe "#class_active" do
    it "has default value" do
      expect(config.class_active).to eq("active")
    end

    it "uses configured value" do
      ActiveLinkTo.configuration.class_active = "custom-active"
      current_path_is("/foo")

      active_link = active_link_to("label", "/foo")
      expect(active_link).to have_tag("a", with: { class: "custom-active" })
    end

    it "uses explicit value" do
      ActiveLinkTo.configuration.class_active = "custom-active"
      current_path_is("/foo")

      active_link = active_link_to("label", "/foo", class_active: "explicit-active")
      expect(active_link).to have_tag("a", with: { class: "explicit-active" })
    end
  end

  describe "#class_inactive" do
    it "has default value" do
      expect(config.class_inactive).to eq("")
    end

    it "uses configured value" do
      ActiveLinkTo.configuration.class_inactive = "custom-inactive"
      current_path_is("/foo")

      active_link = active_link_to("label", "/bar")
      expect(active_link).to have_tag("a", with: { class: "custom-inactive" })
    end

    it "uses explicit value" do
      ActiveLinkTo.configuration.class_inactive = "custom-active"
      current_path_is("/foo")

      active_link = active_link_to("label", "/bar", class_inactive: "explicit-inactive")
      expect(active_link).to have_tag("a", with: { class: "explicit-inactive" })
    end
  end

  describe "#active_disable" do
    it "has default value" do
      expect(config.active_disable).to eq(false)
    end

    it "uses configured value" do
      ActiveLinkTo.configuration.active_disable = true
      current_path_is("/foo")

      active_link = active_link_to("label", "/foo")
      expect(active_link).to have_tag("span", with: { class: "active" }, text: "label")
    end

    it "uses explicit value" do
      ActiveLinkTo.configuration.active_disable = true
      current_path_is("/foo")

      active_link = active_link_to("label", "/foo", active_disable: false)
      expect(active_link).to have_tag("a", with: { href: "/foo", class: "active" }, text: "label")
    end
  end

  describe "#wrap_tag" do
    it "has default value" do
      expect(config.wrap_tag).to eq(nil)
    end

    it "uses configured value" do
      ActiveLinkTo.configuration.wrap_tag = "configured-tag"
      current_path_is("/foo")

      link = active_link_to("label", "/foo")
      expect(link).to have_tag("configured-tag", with: { class: "active" }) do
        with_tag("a")
      end
    end

    it "uses explicit value" do
      ActiveLinkTo.configuration.wrap_tag = "configured-tag"
      current_path_is("/foo")

      link = active_link_to("label", "/foo", wrap_tag: "explicit-tag")
      expect(link).to have_tag("explicit-tag", with: { class: "active" }) do
        with_tag("a")
      end

      link = active_link_to("label", "/foo", wrap_tag: nil)
      expect(link).to have_tag("a", with: { class: "active" })
    end
  end

  describe "#wrap_class" do
    it "has default value" do
      expect(config.wrap_class).to eq("")
    end

    it "uses configured value" do
      ActiveLinkTo.configuration.wrap_tag   = "configured-tag"
      ActiveLinkTo.configuration.wrap_class = "configured-class"
      current_path_is("/foo")

      link = active_link_to("label", "/foo")
      expect(link).to have_tag("configured-tag", with: { class: %w[configured-class active] }) do
        with_tag("a")
      end
    end

    it "uses explicit value" do
      ActiveLinkTo.configuration.wrap_tag   = "configured-tag"
      ActiveLinkTo.configuration.wrap_class = "configured-class"
      current_path_is("/foo")

      link = active_link_to("label", "/foo", wrap_class: "explicit-class")
      expect(link).to have_tag("configured-tag", with: { class: %w[explicit-class active] }) do
        with_tag("a")
      end
    end
  end
end
