# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveLinkTo do
  describe "#is_active_link?" do
    it "works for the boolean flag" do
      expect(is_active_link?("/any-path", true)).to be(true)
      expect(is_active_link?("/any-path", false)).to be(false)
    end

    it "works for the :inclusive flag" do
      current_path_is("/foo")
      expect(is_active_link?("/foo", :inclusive)).to be(true)

      current_path_is("/foo?param=bar")
      expect(is_active_link?("/foo", :inclusive)).to be(true)

      current_path_is("/foo/child/sub-child")
      expect(is_active_link?("/foo", :inclusive)).to be(true)

      current_path_is("/bar")
      expect(is_active_link?("/foo", :inclusive)).to be(false)
    end

    it "works without value as :inclusive flag is implied" do
      current_path_is("/foo/bar")
      expect(is_active_link?("/foo")).to be(true)
      expect(is_active_link?("/bar")).to be(false)
    end

    it "doesn't match on a partial path value" do
      current_path_is("/foo/bar")
      expect(is_active_link?("/foo/ba")).to be(false)
    end

    it "works when path value specifies ending slash" do
      current_path_is("/foo/bar")
      expect(is_active_link?("/foo/")).to be(true)
    end

    it "doesn't match if path value is partial with ending slash" do
      current_path_is("/foo_bar")
      expect(is_active_link?("/foo/")).to be(false)
    end

    it "matches on path with dissimilar params" do
      current_path_is("/foo?param=bar")
      expect(is_active_link?("/foo?attr=something-else")).to be(true)
    end

    it "works for the :exclusive flag" do
      current_path_is("/foo")
      expect(is_active_link?("/foo", :exclusive)).to be(true)

      current_path_is("/foo?param=bar")
      expect(is_active_link?("/foo", :exclusive)).to be(true)

      current_path_is("/foo/bar")
      expect(is_active_link?("/foo", :exclusive)).to be(false)
    end

    it "matches path with dissimilar params for the :exclusive flag" do
      current_path_is("/foo?param=bar")
      expect(is_active_link?("/foo?attr=example", :exclusive)).to be(true)
    end

    it "works for the :exact flag" do
      current_path_is("/foo?param=bar")

      expect(is_active_link?("/foo?param=bar", :exact)).to be(true)
      expect(is_active_link?("/foo?param=other", :exact)).to be(false)
      expect(is_active_link?("/foo", :exact)).to be(false)

      current_path_is("/foo")
      expect(is_active_link?("/foo?param=bar", :exact)).to be(false)
    end

    it "works for the regex flag" do
      current_path_is("/foo")
      expect(is_active_link?("/", %r{^/foo})).to be(true)

      current_path_is("/foo/bar")
      expect(is_active_link?("/", %r{^/fo})).to be(true)

      current_path_is("/bar")
      expect(is_active_link?("/", %r{^/fo})).to be(false)
    end

    it "works for an array of controller and action names as a flag" do
      # currently active controller/action pair
      params[:controller] = "foos"
      params[:action]     = "bar"

      expect(is_active_link?("/", [["foos"], ["bar"]])).to be(true)
      expect(is_active_link?("/", [["foos"], %w[bar baz]])).to be(true)
      expect(is_active_link?("/", [%w[foos bars], ["bar"]])).to be(true)
      expect(is_active_link?("/", [%w[foos bars], %w[bar baz]])).to be(true)

      expect(is_active_link?("/", %w[foos bar])).to be(true)
      expect(is_active_link?("/", ["foos", %w[bar baz]])).to be(true)
      expect(is_active_link?("/", [%w[foos bars], "bar"])).to be(true)

      expect(is_active_link?("/", %w[others bar])).to be(false)
      expect(is_active_link?("/", %w[foos other])).to be(false)
    end

    it "works when flag is defined as a hash" do
      # currently active controller/action pair
      params[:controller] = "foos"
      params[:action]     = "bar"

      expect(is_active_link?("/", [{ foos: :bar }])).to be(true)
      expect(is_active_link?("/", [{ "foos" => "bar" }])).to be(true)
      expect(is_active_link?("/", [{ eggs: :ham, foos: :bar }])).to be(true)

      expect(is_active_link?("/", [{ foos: :foo }])).to be(false)
      expect(is_active_link?("/", [{ bars: :bar }])).to be(false)
    end

    it "works for parameter matching" do
      params[:a] = 1

      expect(is_active_link?("/", { a: 1 })).to be(true)
      expect(is_active_link?("/", { a: 1, b: nil })).to be(true)

      expect(is_active_link?("/", { a: 1, b: 2 })).to be(false)
      expect(is_active_link?("/", { a: 2 })).to be(false)

      params[:b] = 2

      expect(is_active_link?("/", { a: 1, b: 2 })).to be(true)
      expect(is_active_link?("/", { a: 1, b: 2, c: nil })).to be(true)

      expect(is_active_link?("/", { a: 1 })).to be(true)
      expect(is_active_link?("/", { b: 2 })).to be(true)
    end

    it "matches is path value has anchor" do
      current_path_is("/foo")
      expect(is_active_link?("/foo#anchor", :exclusive)).to be(true)
    end

    it "returns false if request is nil (like in email templates)" do
      allow(self).to receive(:request).and_return(nil)
      expect(is_active_link?("/foo")).to be(false)
    end
  end

  describe "#active_link_to_class" do
    it "returns css class name for active links" do
      current_path_is("/foo")
      expect(active_link_to_class("/foo")).to eq("active")
      expect(active_link_to_class("/other")).to eq("")
    end

    it "can use custom css class names for active and inactive links" do
      current_path_is("/foo")
      expect(active_link_to_class("/foo", class_active: "on")).to eq("on")
      expect(active_link_to_class("/other", class_inactive: "off")).to eq("off")
    end
  end

  describe "#active_link_to" do
    it "renders link with active state" do
      current_path_is("/foo")
      link = active_link_to("label", "/foo")
      expect(link).to have_tag("a", with: { href: "/foo", class: "active" }, text: "label")

      link = active_link_to("label", "/other")
      expect(link).to have_tag("a", without: { class: "active" })
    end

    it "doesn't clobber existing class names" do
      current_path_is("/foo")
      link = active_link_to("label", "/foo", class: "existing")
      expect(link).to have_tag("a", with: { class: %w[active existing] })
    end

    it "works with custom active and inactive class names" do
      current_path_is("/foo")

      active_link = active_link_to("label", "/foo", class_active: "on")
      expect(active_link).to have_tag("a", with: { class: "on" })

      inactive_link = active_link_to("label", "/bar", class_inactive: "off")
      expect(inactive_link).to have_tag("a", with: { class: "off" })
    end

    it "can render span instead of an active link" do
      current_path_is("/foo")
      active_link = active_link_to("label", "/foo", active_disable: true)
      expect(active_link).to have_tag("span", with: { class: "active" }, text: "label")

      inactive_link = active_link_to("label", "/bar", active_disable: true)
      expect(inactive_link).to have_tag("a", without: { class: "active" }, text: "label")
    end

    it "can use wrapper element around active link" do
      current_path_is("/foo")
      link = active_link_to("label", "/foo", wrap_tag: :li, class: "existing")
      expect(link).to have_tag("li", with: { class: "active" }) do
        with_tag("a", without: { class: "active" }, with: { class: "existing" })
      end
    end

    it "should not modify passed-in params" do
      current_path_is("/foo")
      params = { class: "testing", active: :inclusive }

      link = active_link_to "label", "/foo", params
      expect(link).to have_tag("a", with: { href: "/foo", class: %w[active testing] }, text: "label")
      expect(params).to eq({ class: "testing", active: :inclusive })
    end

    it "marks active link with aria attribute" do
      current_path_is("/foo")
      active_link = active_link_to("label", "/foo")
      expect(active_link).to have_tag("a", with: { "aria-current": "page", class: "active" })

      inactive_link = active_link_to("label", "/bar")
      expect(inactive_link).to have_tag("a", without: { "aria-current": "page", class: "active" })
    end

    it "renders link with utf8 characters" do
      current_path_is("/äöü")
      link = active_link_to("label", "/äöü")
      expect(link).to have_tag("a", with: { href: "/äöü", class: "active" })
    end
  end
end
