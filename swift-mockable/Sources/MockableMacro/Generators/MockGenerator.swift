import SwiftSyntax
import SwiftSyntaxBuilder


struct MockGenerator {
    private let variablePrefixGenerator = VariablePrefixGenerator()
    private let variablesImplementationGenerator = VariablesImplementationGenerator()
    private let callsCountGenerator = CallsCountGenerator()
    private let calledGenerator = CalledGenerator()
    private let receivedArgumentsGenerator = ReceivedArgumentsGenerator()
    private let receivedInvocationsGenerator = ReceivedInvocationsGenerator()
    private let returnValueGenerator = ReturnValueGenerator()
    private let closureGenerator = ClosureGenerator()
    private let functionImplementationGenerator = FunctionImplementationGenerator()

    func classDeclaration(for protocolDeclaration: ProtocolDeclSyntax) -> ClassDeclSyntax {
        let identifier =  TokenSyntax.identifier("Mock" + protocolDeclaration.identifier.text)

        let variableDeclarations = protocolDeclaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }

        let functionDeclarations = protocolDeclaration.memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
        
        return ClassDeclSyntax(
            identifier: identifier,
            inheritanceClause: TypeInheritanceClauseSyntax {
                InheritedTypeSyntax(
                    typeName: SimpleTypeIdentifierSyntax(name: protocolDeclaration.identifier)
                )
            },
            memberBlockBuilder: {
                for variableDeclaration in variableDeclarations {
                    variablesImplementationGenerator.variablesDeclarations(
                        protocolVariableDeclaration: variableDeclaration
                    )
                }

                for functionDeclaration in functionDeclarations {
                    let variablePrefix = variablePrefixGenerator.text(for: functionDeclaration)
                    let parameterList = functionDeclaration.signature.input.parameterList

                    callsCountGenerator.variableDeclaration(variablePrefix: variablePrefix)
                    calledGenerator.variableDeclaration(variablePrefix: variablePrefix)

                    if !parameterList.isEmpty {
                        receivedArgumentsGenerator.variableDeclaration(
                            variablePrefix: variablePrefix,
                            parameterList: parameterList
                        )
                        receivedInvocationsGenerator.variableDeclaration(
                            variablePrefix: variablePrefix,
                            parameterList: parameterList
                        )
                    }

                    if let returnType = functionDeclaration.signature.output?.returnType {
                        returnValueGenerator.variableDeclaration(
                            variablePrefix: variablePrefix,
                            functionReturnType: returnType
                        )
                    }

                    closureGenerator.variableDeclaration(
                        variablePrefix: variablePrefix,
                        functionSignature: functionDeclaration.signature
                    )

                    functionImplementationGenerator.declaration(
                        variablePrefix: variablePrefix,
                        protocolFunctionDeclaration: functionDeclaration
                    )
                }
            }
        )
    }
}

