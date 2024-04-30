# frozen_string_literal: true

require 'active_support/inflector'

module Wizard
  class ConceptGenerator
    attr_reader :type

    def initialize(**args)
      @type = args[:type]
    end

    def generate(model, name, context = nil)
      materials = [model, type, name]
      materials.insert(1, context) unless context.nil?

      filename = materials.map { |material| ActiveSupport::Inflector.underscore(material) }.join("/")

      false if File.exist?("#{filename}.rb")

      content = File.read("lib/templates/concept.rb.txt")

      content["_MODEL_"] = model.camelize
      content["::_CONTEXT_"] = context.nil? ? "" : "::#{context.camelize}"
      content["_NAME_"] = name.camelize
      content["_CONCEPT_"] = type.camelize while content.include?("_CONCEPT_")

      filename
    end
  end
end