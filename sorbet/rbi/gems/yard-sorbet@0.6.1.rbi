# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `yard-sorbet` gem.
# Please instead update this file by running `bin/tapioca gem yard-sorbet`.

module YARDSorbet; end

# Extract & re-add directives to a docstring
module YARDSorbet::Directives
  class << self
    sig { params(docstring: ::String, directives: T::Array[::String]).void }
    def add_directives(docstring, directives); end

    sig { params(docstring: T.nilable(::String)).returns([::YARD::Docstring, T::Array[::String]]) }
    def extract_directives(docstring); end
  end
end

# Custom YARD Handlers
#
# @see https://rubydoc.info/gems/yard/YARD/Handlers/Base YARD Base Handler documentation
module YARDSorbet::Handlers; end

# Apllies an `@abstract` tag to `abstract!`/`interface!` modules (if not alerady present).
class YARDSorbet::Handlers::AbstractDSLHandler < ::YARD::Handlers::Ruby::Base
  sig { void }
  def process; end
end

# Extra text for class namespaces
YARDSorbet::Handlers::AbstractDSLHandler::CLASS_TAG_TEXT = T.let(T.unsafe(nil), String)

# The text accompanying the `@abstract` tag.
#
# @see https://github.com/lsegal/yard/blob/main/templates/default/docstring/html/abstract.erb The `@abstract` tag template
YARDSorbet::Handlers::AbstractDSLHandler::TAG_TEXT = T.let(T.unsafe(nil), String)

# Handle `enums` calls, registering enum values as constants
class YARDSorbet::Handlers::EnumsHandler < ::YARD::Handlers::Ruby::Base
  sig { void }
  def process; end

  private

  sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Boolean) }
  def const_assign_node?(node); end
end

# Extends any modules included via `mixes_in_class_methods`
#
# @see https://sorbet.org/docs/abstract#interfaces-and-the-included-hook Sorbet `mixes_in_class_methods` documentation
class YARDSorbet::Handlers::IncludeHandler < ::YARD::Handlers::Ruby::Base
  sig { void }
  def process; end

  private

  sig { returns(::YARD::CodeObjects::NamespaceObject) }
  def included_in; end
end

# Tracks modules that invoke `mixes_in_class_methods` for use in {IncludeHandler}
#
# @see https://sorbet.org/docs/abstract#interfaces-and-the-included-hook Sorbet `mixes_in_class_methods` documentation
class YARDSorbet::Handlers::MixesInClassMethodsHandler < ::YARD::Handlers::Ruby::Base
  sig { void }
  def process; end

  class << self
    sig { params(code_obj: ::String).returns(T.nilable(::String)) }
    def mixed_in_class_methods(code_obj); end
  end
end

# A YARD Handler for Sorbet type declarations
class YARDSorbet::Handlers::SigHandler < ::YARD::Handlers::Ruby::Base
  # Swap the method definition docstring and the sig docstring.
  # Parse relevant parts of the `sig` and include them as well.
  sig { void }
  def process; end

  private

  sig do
    params(
      method_node: ::YARD::Parser::Ruby::AstNode,
      node: ::YARD::Parser::Ruby::AstNode,
      docstring: ::YARD::Docstring
    ).void
  end
  def parse_params(method_node, node, docstring); end

  sig { params(node: ::YARD::Parser::Ruby::AstNode, docstring: ::YARD::Docstring).void }
  def parse_return(node, docstring); end

  sig { params(method_node: ::YARD::Parser::Ruby::AstNode, docstring: ::YARD::Docstring).void }
  def parse_sig(method_node, docstring); end
end

# These node types attached to sigs represent attr_* declarations
YARDSorbet::Handlers::SigHandler::ATTR_NODE_TYPES = T.let(T.unsafe(nil), Array)

# Class-level handler that folds all `const` and `prop` declarations into the constructor documentation
# this needs to be injected as a module otherwise the default Class handler will overwrite documentation
#
# @note this module is included in `YARD::Handlers::Ruby::ClassHandler`
module YARDSorbet::Handlers::StructClassHandler
  sig { void }
  def process; end

  private

  sig do
    params(
      object: ::YARD::CodeObjects::MethodObject,
      props: T::Array[::YARDSorbet::TStructProp],
      docstring: ::YARD::Docstring,
      directives: T::Array[::String]
    ).void
  end
  def decorate_t_struct_init(object, props, docstring, directives); end

  # Create a virtual `initialize` method with all the `prop`/`const` arguments
  sig { params(props: T::Array[::YARDSorbet::TStructProp], class_ns: ::YARD::CodeObjects::ClassObject).void }
  def process_t_struct_props(props, class_ns); end

  sig { params(props: T::Array[::YARDSorbet::TStructProp]).returns(T::Array[[::String, T.nilable(::String)]]) }
  def to_object_parameters(props); end
end

# Handles all `const`/`prop` calls, creating accessor methods, and compiles them for later usage at the class level
# in creating a constructor
class YARDSorbet::Handlers::StructPropHandler < ::YARD::Handlers::Ruby::Base
  sig { void }
  def process; end

  private

  # Add the source and docstring to the method object
  sig { params(object: ::YARD::CodeObjects::MethodObject, prop: ::YARDSorbet::TStructProp).void }
  def decorate_object(object, prop); end

  # Get the default prop value
  sig { returns(T.nilable(::String)) }
  def default_value; end

  sig { params(name: ::String).returns(::YARDSorbet::TStructProp) }
  def make_prop(name); end

  # Register the field explicitly as an attribute.
  # While `const` attributes are immutable, `prop` attributes may be reassigned.
  sig { params(object: ::YARD::CodeObjects::MethodObject, name: ::String).void }
  def register_attrs(object, name); end

  # Store the prop for use in the constructor definition
  sig { params(prop: ::YARDSorbet::TStructProp).void }
  def update_state(prop); end
end

# Helper methods for working with `YARD` AST Nodes
module YARDSorbet::NodeUtils
  class << self
    # Traverese AST nodes in breadth-first order
    #
    # @note This will skip over some node types.
    # @yield [YARD::Parser::Ruby::AstNode]
    sig do
      params(
        node: ::YARD::Parser::Ruby::AstNode,
        _blk: T.proc.params(n: ::YARD::Parser::Ruby::AstNode).void
      ).void
    end
    def bfs_traverse(node, &_blk); end

    # Gets the node that a sorbet `sig` can be attached do, bypassing visisbility modifiers and the like
    sig do
      params(
        node: ::YARD::Parser::Ruby::AstNode
      ).returns(T.any(::YARD::Parser::Ruby::MethodCallNode, ::YARD::Parser::Ruby::MethodDefinitionNode))
    end
    def get_method_node(node); end

    # Find and return the adjacent node (ascending)
    #
    # @raise [IndexError] if the node does not have an adjacent sibling (ascending)
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(::YARD::Parser::Ruby::AstNode) }
    def sibling_node(node); end
  end
end

# Command node types that can have type signatures
YARDSorbet::NodeUtils::ATTRIBUTE_METHODS = T.let(T.unsafe(nil), Array)

# Node types that can have type signatures
YARDSorbet::NodeUtils::SIGABLE_NODE = T.type_alias { T.any(::YARD::Parser::Ruby::MethodCallNode, ::YARD::Parser::Ruby::MethodDefinitionNode) }

# Skip these method contents during BFS node traversal, they can have their own nested types via `T.Proc`
YARDSorbet::NodeUtils::SKIP_METHOD_CONTENTS = T.let(T.unsafe(nil), Array)

# Translate `sig` type syntax to `YARD` type syntax.
module YARDSorbet::SigToYARD
  class << self
    # @see https://yardoc.org/types.html
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert(node); end

    private

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(::String) }
    def build_generic_type(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_aref(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_array(node); end

    sig { params(node: ::YARD::Parser::Ruby::MethodCallNode).returns(T::Array[::String]) }
    def convert_call(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_collection(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_hash(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_list(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_node(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_node_type(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_ref(node); end

    sig { params(node: ::YARD::Parser::Ruby::MethodCallNode).returns(T::Array[::String]) }
    def convert_t_method(node); end

    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_unknown(node); end
  end
end

# Used to store the details of a `T::Struct` `prop` definition
class YARDSorbet::TStructProp < ::T::Struct
  const :default, T.nilable(::String)
  const :doc, ::String
  const :prop_name, ::String
  const :source, ::String
  const :types, T::Array[::String]

  class << self
    def inherited(s); end
  end
end

# Helper methods for working with `YARD` tags
module YARDSorbet::TagUtils
  class << self
    sig do
      params(
        docstring: ::YARD::Docstring,
        tag_name: ::String,
        name: T.nilable(::String)
      ).returns(T.nilable(::YARD::Tags::Tag))
    end
    def find_tag(docstring, tag_name, name); end

    # Create or update a `YARD` tag with type information
    sig do
      params(
        docstring: ::YARD::Docstring,
        tag_name: ::String,
        types: T.nilable(T::Array[::String]),
        name: T.nilable(::String),
        text: ::String
      ).void
    end
    def upsert_tag(docstring, tag_name, types = T.unsafe(nil), name = T.unsafe(nil), text = T.unsafe(nil)); end
  end
end

# {https://rubygems.org/gems/yard-sorbet Version history}
YARDSorbet::VERSION = T.let(T.unsafe(nil), String)
