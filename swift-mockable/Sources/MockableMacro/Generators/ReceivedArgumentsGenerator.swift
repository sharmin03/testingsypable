import SwiftSyntax
import SwiftSyntaxBuilder

struct ReceivedArgumentsGenerator {
    func variableDeclaration(variablePrefix: String, parameterList: FunctionParameterListSyntax) -> VariableDeclSyntax {
        let identifier = variableIdentifier(variablePrefix: variablePrefix, parameterList: parameterList)
        let type = variableType(parameterList: parameterList)

        return VariableDeclSyntax(
            bindingKeyword: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: identifier),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: type
                    )
                )
            }
        )
    }

    private func variableType(parameterList: FunctionParameterListSyntax) -> TypeSyntaxProtocol {
        let variableType: TypeSyntaxProtocol

        if parameterList.count == 1, var onlyParameterType = parameterList.first?.type {
            if let attributedType = onlyParameterType.as(AttributedTypeSyntax.self) {
                onlyParameterType = attributedType.baseType
            }

            if onlyParameterType.is(OptionalTypeSyntax.self) {
                variableType = onlyParameterType
            } else if onlyParameterType.is(FunctionTypeSyntax.self) {
                variableType = OptionalTypeSyntax(
                    wrappedType: TupleTypeSyntax(
                        elements: TupleTypeElementListSyntax {
                            TupleTypeElementSyntax(type: onlyParameterType)
                        }
                    ),
                    questionMark: .postfixQuestionMarkToken()
                )
            } else {
                variableType = OptionalTypeSyntax(
                    wrappedType: onlyParameterType,
                    questionMark: .postfixQuestionMarkToken()
                )
            }
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
            variableType = OptionalTypeSyntax(
                wrappedType: TupleTypeSyntax(elements: tupleElements),
                questionMark: .postfixQuestionMarkToken()
            )
        }

        return variableType
    }

    func assignValueToVariableExpression(variablePrefix: String, parameterList: FunctionParameterListSyntax) -> SequenceExprSyntax {
        let identifier = variableIdentifier(variablePrefix: variablePrefix, parameterList: parameterList)

        return SequenceExprSyntax {
            IdentifierExprSyntax(identifier: identifier)
            AssignmentExprSyntax()
            TupleExprSyntax {
                for parameter in parameterList {
                    TupleExprElementSyntax(
                        expression: IdentifierExprSyntax(
                            identifier: parameter.secondName ?? parameter.firstName
                        )
                    )
                }
            }
        }
    }

    private func variableIdentifier(variablePrefix: String, parameterList: FunctionParameterListSyntax) -> TokenSyntax {
        if parameterList.count == 1, let onlyParameter = parameterList.first {
             let parameterNameToken = onlyParameter.secondName ?? onlyParameter.firstName
             let parameterNameText = parameterNameToken.text
             let capitalizedParameterName = parameterNameText.prefix(1).uppercased() + parameterNameText.dropFirst()

             return .identifier(variablePrefix + "Received" + capitalizedParameterName)
         } else {
             return .identifier(variablePrefix + "ReceivedArguments")
         }
    }
}
