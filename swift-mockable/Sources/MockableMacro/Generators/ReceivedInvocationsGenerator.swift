import SwiftSyntax
import SwiftSyntaxBuilder

struct ReceivedInvocationsGenerator {
    func variableDeclaration(variablePrefix: String, parameterList: FunctionParameterListSyntax) -> VariableDeclSyntax {
        let identifier = variableIdentifier(variablePrefix: variablePrefix)
        let elementType = arrayElementType(parameterList: parameterList)

        return VariableDeclSyntax(
            bindingKeyword: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: identifier),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: ArrayTypeSyntax(elementType: elementType)
                    ),
                    initializer: InitializerClauseSyntax(
                        value: ArrayExprSyntax(elementsBuilder: {})
                    )
                )
            }
        )
    }

    private func arrayElementType(parameterList: FunctionParameterListSyntax) -> TypeSyntaxProtocol {
        let arrayElementType: TypeSyntaxProtocol

        if parameterList.count == 1, var onlyParameterType = parameterList.first?.type {
            if let attributedType = onlyParameterType.as(AttributedTypeSyntax.self) {
                onlyParameterType = attributedType.baseType
            }

            arrayElementType = onlyParameterType
        } else {
            let tupleElements = TupleTypeElementListSyntax {
                for parameter in parameterList {
                    TupleTypeElementSyntax(
                        name: parameter.secondName ?? parameter.firstName,
                        colon: .colonToken(),
                        type: {
                            if let attributedType = parameter.type.as(AttributedTypeSyntax.self) {
                                return attributedType.baseType
                            } else {
                                return parameter.type
                            }
                        }()
                    )
                }
            }
            arrayElementType = TupleTypeSyntax(elements: tupleElements)
        }

        return arrayElementType
    }

    func appendValueToVariableExpression(variablePrefix: String, parameterList: FunctionParameterListSyntax) -> FunctionCallExprSyntax {
        let identifier = variableIdentifier(variablePrefix: variablePrefix)
        let calledExpression = MemberAccessExprSyntax(
            base: IdentifierExprSyntax(identifier: identifier),
            dot: .periodToken(),
            name: .identifier("append")
        )
        let argument = appendArgumentExpression(parameterList: parameterList)

        return FunctionCallExprSyntax(
            calledExpression: calledExpression,
            leftParen: .leftParenToken(),
            argumentList: argument,
            rightParen: .rightParenToken()
        )
    }

    private func appendArgumentExpression(parameterList: FunctionParameterListSyntax) -> TupleExprElementListSyntax {
        let tupleArgument = TupleExprSyntax(
            elementListBuilder: {
                for parameter in parameterList {
                    TupleExprElementSyntax(
                        expression: IdentifierExprSyntax(
                            identifier: parameter.secondName ?? parameter.firstName
                        )
                    )
                }
            }
        )

        return TupleExprElementListSyntax {
            TupleExprElementSyntax(expression: tupleArgument)
        }
    }

    private func variableIdentifier(variablePrefix: String) -> TokenSyntax {
        TokenSyntax.identifier(variablePrefix + "ReceivedInvocations")
    }
}
