import SwiftSyntax
import SwiftSyntaxBuilder

struct FunctionImplementationGenerator {
    private let callsCountGenerator = CallsCountGenerator()
    private let receivedArgumentsGenerator = ReceivedArgumentsGenerator()
    private let receivedInvocationsGenerator = ReceivedInvocationsGenerator()
    private let throwableErrorGenerator = ThrowableErrorGenerator()
    private let closureGenerator = ClosureGenerator()
    private let returnValueGenerator = ReturnValueGenerator()

    func declaration(
        variablePrefix: String,
        protocolFunctionDeclaration: FunctionDeclSyntax
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            attributes: protocolFunctionDeclaration.attributes,
            modifiers: protocolFunctionDeclaration.modifiers,
            funcKeyword: protocolFunctionDeclaration.funcKeyword,
            identifier: protocolFunctionDeclaration.identifier,
            genericParameterClause: protocolFunctionDeclaration.genericParameterClause,
            signature: protocolFunctionDeclaration.signature,
            genericWhereClause: protocolFunctionDeclaration.genericWhereClause,
            bodyBuilder: {
                let parameterList = protocolFunctionDeclaration.signature.input.parameterList

                callsCountGenerator.incrementVariableExpression(variablePrefix: variablePrefix)

                if !parameterList.isEmpty {
                    receivedArgumentsGenerator.assignValueToVariableExpression(
                        variablePrefix: variablePrefix,
                        parameterList: parameterList
                    )
                    receivedInvocationsGenerator.appendValueToVariableExpression(
                        variablePrefix: variablePrefix,
                        parameterList: parameterList
                    )
                }

                if protocolFunctionDeclaration.signature.effectSpecifiers?.throwsSpecifier != nil {
                    throwableErrorGenerator.throwErrorExpression(variablePrefix: variablePrefix)
                }

                if protocolFunctionDeclaration.signature.output == nil {
                    closureGenerator.callExpression(
                        variablePrefix: variablePrefix,
                        functionSignature: protocolFunctionDeclaration.signature
                    )
                } else {
                    returnExpression(
                        variablePrefix: variablePrefix,
                        protocolFunctionDeclaration: protocolFunctionDeclaration
                    )
                }
            }
        )
    }

    private func returnExpression(variablePrefix: String, protocolFunctionDeclaration: FunctionDeclSyntax) -> IfExprSyntax {
        return IfExprSyntax(
            conditions: ConditionElementListSyntax {
                ConditionElementSyntax(
                    condition: .expression(
                        ExprSyntax(
                            SequenceExprSyntax {
                                IdentifierExprSyntax(identifier: .identifier(variablePrefix + "Closure"))
                                BinaryOperatorExprSyntax(operatorToken: .binaryOperator("!="))
                                NilLiteralExprSyntax()
                            }
                        )
                    )
                )
            },
            elseKeyword: .keyword(.else),
            elseBody: .codeBlock(
                CodeBlockSyntax {
                    returnValueGenerator.returnStatement(variablePrefix: variablePrefix)
                }
            ),
            bodyBuilder: {
                ReturnStmtSyntax(
                    expression: closureGenerator.callExpression(
                        variablePrefix: variablePrefix,
                        functionSignature: protocolFunctionDeclaration.signature
                    )
                )
            }
        )
    }
}
