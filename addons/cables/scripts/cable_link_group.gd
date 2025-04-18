## Thin wrapper around [CallableSink] that adds some
## functionality specific to [Cable]s.
class_name CableLinkGroup extends CallableSink

## Alias of [method call_each_and_clear]
func unlink_all() -> void:
	call_each_and_clear()

## Convenience to reduce boilerplate of [method with_lifetime]
## by inferring [method NodeWithLifetime.from] while creating the new link group.
static func with_lifetime_of(node: Node) -> CableLinkGroup:
	return CableLinkGroup.with_lifetime(NodeWithLifetime.from(node))

## Creates a new [CableLinkGroup], and connects its
## [method unlink_all] method as a callable to the given
## [param lifetime]'s [signal NodeWithLifetime.node_destroyed] signal.
static func with_lifetime(lifetime: NodeWithLifetime) -> CableLinkGroup:
	var result := CableLinkGroup.new()
	var unlink_all := func(): result.unlink_all()
	lifetime.node_destroyed.connect(unlink_all)
	return result
