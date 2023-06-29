import SwiftSyntax
import SwiftSyntaxBuilder

struct ThrowableErrorGenerator {
    func variableDeclaration(variablePrefix: String) -> VariableDeclSyntax {
        VariableDeclSyntax(
            bindingKeyword: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(
                        identifier: variableIdentifier(variablePrefix: variablePrefix)
                    ),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: OptionalTypeSyntax(
                            wrappedType: SimpleTypeIdentifierSyntax(name: .identifier("Error"))
                        )
                    )
                )
            }
        )
    }

    func throwErrorExpression(variablePrefix: String) -> IfExprSyntax {
        IfExprSyntax(
            conditions: ConditionElementListSyntax {
                ConditionElementSyntax(
                    condition: .optionalBinding(
                        OptionalBindingConditionSyntax(
                           bindingKeyword: .keyword(.let),
                           pattern: IdentifierPatternSyntax(
                               identifier: variableIdentifier(variablePrefix: variablePrefix)
                           )
                       )
                    )
                )
            },
            bodyBuilder: {
                ThrowStmtSyntax(
                    expression: IdentifierExprSyntax(
                        identifier: variableIdentifier(variablePrefix: variablePrefix)
                    )
                )
            }
        )
    }

    private func variableIdentifier(variablePrefix: String) -> TokenSyntax {
        TokenSyntax.identifier(variablePrefix + "ThrowableError")
    }
}
