import SwiftSyntax
import SwiftSyntaxBuilder

struct VariablePrefixGenerator {
    func text(for functionDeclaration: FunctionDeclSyntax) -> String {
        var parts: [String] = [functionDeclaration.identifier.text]

        let parameterList = functionDeclaration.signature.input.parameterList

        let parameters = parameterList
            .map { $0.firstName.text }
            .filter { $0 != "_" }
            .map { $0.capitalizingFirstLetter() }

        parts.append(contentsOf: parameters)

        return parts.joined()
    }
}

extension String {
    fileprivate func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
