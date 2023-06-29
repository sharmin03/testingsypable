
@attached(peer, names: arbitrary)
public macro Mockable() -> () = #externalMacro(
    module: "MockableMacro",
    type: "MockableMacro"
)
